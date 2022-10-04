#include "popupview.h"

#include <QApplication>
#include <QColor>
#include <QCursor>
#include <QPoint>
#include <QPointF>
#include <QQuickView>
#include <QRect>
#include <QRectF>
#include <QUrl>
#include <QWindow>

#include <QtQml>

using namespace gs::uicomponents;

PopupView::PopupView(QQuickItem* parent) : QQuickItem(parent)
{
    setObjectName("PopupView");
    m_view = new QQuickView(qmlEngine(this), nullptr);
}

QQuickItem* PopupView::parentItem() const
{
    if (!parent()) {
        return nullptr;
    }

    return qobject_cast<QQuickItem*>(parent());
}

void PopupView::setParentItem(QQuickItem* item)
{
    if (m_parentItem == item) {
        return;
    }

    setParent(item);
    m_parentItem = item;
    emit parentItemChanged();
}

QQuickItem* PopupView::contentItem() const
{
    return m_contentItem;
}

void PopupView::setContentItem(QQuickItem* item)
{
    if (m_contentItem == item) {
        return;
    }

    m_contentItem = item;
    emit contentItemChanged();
}

void PopupView::close()
{
    qApp->removeEventFilter(this);
    m_view->close();

    if (m_loop.isRunning()) {
        m_loop.exit();
    }
}

void PopupView::close(const int& code)
{
    QVariantMap result = {{"code", code}};
    setRet(result);
    close();
}

void PopupView::close(const QVariantMap& ret)
{
    setRet(ret);
    close();
}

QVariantMap PopupView::exec()
{
    if (m_loop.isRunning()) {
        return {{"code", static_cast<int>(Ret::Code::Undefined)}};
    }

    open();
    m_loop.exec();
    return m_ret;
}

void PopupView::open()
{
    m_view = new QQuickView(qmlEngine(this), nullptr);

    if (isDialog()) {
        setShowArrow(false);
        m_view->setFlags(Qt::Dialog);
    } else {
        m_view->setFlags(Qt::Tool |
                         Qt::FramelessWindowHint |
                         Qt::NoDropShadowWindowHint |
                         Qt::BypassWindowManagerHint);
        m_view->setColor(QColor(Qt::transparent));
        setArrowX(parentItem()->width() / 2);
        QPointF pos = parentItem()->mapToGlobal(parentItem()->position());
        m_view->setX(pos.x());
        m_view->setY(pos.y() + parentItem()->height());
    }
    
    m_view->setTitle(m_title);
    m_view->setResizeMode(QQuickView::SizeRootObjectToView);
    m_view->setWidth(m_width);
    m_view->setHeight(m_height);
    // m_view->setContent(QUrl(), nullptr, this);
    m_view->setContent(QUrl(), nullptr, m_contentItem);

    m_view->show();

    qApp->installEventFilter(this);
    // TODO: Add signals
}

void PopupView::toggleOpen()
{
    if (!m_view) {
        open();
    }

    if (isOpened()) {
        close();
    } else {
        open();
    }
}

bool PopupView::isOpened() const
{
    return m_view->isVisible();
}

bool PopupView::modal() const
{
    return m_modal;
}

bool PopupView::isDialog() const
{
    return false;
}

QVariantMap PopupView::ret() const
{
    return m_ret;
}

void PopupView::setRet(const QVariantMap& ret)
{
    if (m_ret == ret) {
        return;
    }

    m_ret = ret;
    emit retChanged();
}

bool PopupView::sync() const
{
    return m_sync;
}

void PopupView::setSync(const bool& sync)
{
    if (m_sync == sync) {
        return;
    }

    m_sync = sync;
    emit syncChanged();
}

QString PopupView::title() const
{
    return m_title;
}

void PopupView::setTitle(const QString& title)
{
    if (m_title == title) {
        return;
    }

    m_title = title;
    emit titleChanged();
}

int PopupView::width() const
{
    return m_width;
}

void PopupView::setWidth(const int& w)
{
    if (m_width == w) {
        return;
    }

    m_width = w;
    emit widthChanged();
}

int PopupView::height() const
{
    return m_height;
}

void PopupView::setHeight(const int& h)
{
    if (m_height == h) {
        return;
    }

    m_height = h;
    emit heightChanged();
}

int PopupView::padding() const
{
    return m_padding;
}

void PopupView::setPadding(const int& p)
{
    if (m_padding == p) {
        return;
    }

    m_padding = p;
    emit paddingChanged();
}

bool PopupView::opensUpward() const
{
    return m_opensUpward;
}

void PopupView::setOpensUpward(const bool& value)
{
    if (m_opensUpward == value) {
        return;
    }

    m_opensUpward = value;
    emit opensUpwardChanged();
}

int PopupView::arrowX() const
{
    return m_arrowX;
}

void PopupView::setArrowX(const int& x)
{
    if (m_arrowX == x) {
        return;
    }

    m_arrowX = x;
    emit arrowXChanged();
}

bool PopupView::showArrow() const
{
    return m_showArrow;
}

void PopupView::setShowArrow(const bool& showArrow)
{
    if (m_showArrow == showArrow) {
        return;
    }

    m_showArrow = showArrow;
    emit showArrowChanged();
}

bool PopupView::eventFilter(QObject* watched, QEvent* event)
{
    if (event->type() == QEvent::Close) {
        close(static_cast<int>(Ret::Code::Cancel));
    }

    if (event->type() == QEvent::MouseButtonPress && !isDialog()) {
        QRect viewRect = m_view->geometry();
        QPoint cursorPos = QCursor::pos();
        bool contains = viewRect.contains(cursorPos);
        if (!contains) {
            QQuickItem* parent = parentItem();
            QPointF localPos = parent->mapFromGlobal(cursorPos);
            QRectF parentRect = QRectF(0, 0, parent->width(), parent->height());
            if (!parentRect.contains(localPos)) {
                close(static_cast<int>(Ret::Code::Cancel));
            }
        }
    }

    if (event->type() == QEvent::ApplicationStateChange && !isDialog()) {
        if (qApp->applicationState() == Qt::ApplicationInactive) {
            close(static_cast<int>(Ret::Code::Cancel));
        }
    }

    return QObject::eventFilter(watched, event);
}
