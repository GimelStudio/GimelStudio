#ifndef GS_UICOMPONENTS_POPUPVIEW_H
#define GS_UICOMPONENTS_POPUPVIEW_H

#include <QEvent>
#include <QEventLoop>
#include <QObject>
#include <QQuickItem>
#include <QQuickView>
#include <QString>
#include <QVariantMap>

#include "global/ret.h"

using namespace gs;

namespace gs::uicomponents
{
class PopupView : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(QQuickItem* parent READ parentItem WRITE setParentItem NOTIFY parentItemChanged)
    Q_PROPERTY(QQuickItem* contentItem READ contentItem WRITE setContentItem NOTIFY contentItemChanged)

    Q_PROPERTY(QVariantMap ret READ ret WRITE setRet NOTIFY retChanged)
    Q_PROPERTY(bool sync READ sync WRITE setSync NOTIFY syncChanged)
    
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(int width READ width WRITE setWidth NOTIFY widthChanged)
    Q_PROPERTY(int height READ height WRITE setHeight NOTIFY heightChanged)
    
    Q_PROPERTY(int padding READ padding WRITE setPadding NOTIFY paddingChanged)

    Q_PROPERTY(bool opensUpward READ opensUpward WRITE setOpensUpward NOTIFY opensUpwardChanged)
    
    Q_PROPERTY(int arrowX READ arrowX WRITE setArrowX NOTIFY arrowXChanged)
    Q_PROPERTY(bool showArrow READ showArrow WRITE setShowArrow NOTIFY showArrowChanged)

public:
    explicit PopupView(QQuickItem* parent = nullptr);
    ~PopupView() override = default;

    QQuickItem* parentItem() const;
    void setParentItem(QQuickItem* item);
    QQuickItem* contentItem() const;
    void setContentItem(QQuickItem* item);

    Q_INVOKABLE void close();
    Q_INVOKABLE void close(const int& code);
    Q_INVOKABLE void close(const QVariantMap& ret);
    Q_INVOKABLE QVariantMap exec();
    Q_INVOKABLE void open();
    Q_INVOKABLE void toggleOpen();

    bool modal() const;
    virtual bool isDialog() const;
    bool isOpened() const;

    QVariantMap ret() const;
    void setRet(const QVariantMap& ret);

    bool sync() const;
    void setSync(const bool& sync);
    
    QString title() const;
    void setTitle(const QString& title);

    int width() const;
    void setWidth(const int& w);

    int height() const;
    void setHeight(const int& h);

    int padding() const;
    void setPadding(const int& p);

    bool opensUpward() const;
    void setOpensUpward(const bool& value);

    int arrowX() const;
    void setArrowX(const int& x);

    bool showArrow() const;
    void setShowArrow(const bool& showArrow);

protected:
    bool eventFilter(QObject* watched, QEvent* event) override;

private:
    QEventLoop m_loop;
    QQuickView* m_view;

    QQuickItem* m_parentItem;
    QQuickItem* m_contentItem;

    bool m_modal = false;

    QVariantMap m_ret;
    bool m_sync = false;

    QString m_title = QString("Popup");
    int m_width = 800;
    int m_height = 600;

    int m_padding = 12;

    bool m_opensUpward = false;

    int m_arrowX;
    bool m_showArrow = true;

signals:
    void parentItemChanged();
    void contentItemChanged();

    void retChanged();
    void syncChanged();

    void titleChanged();
    void widthChanged();
    void heightChanged();

    void paddingChanged();

    void opensUpwardChanged();

    void arrowXChanged();
    void showArrowChanged();
};
} // namespace gs::uicomponents


#endif