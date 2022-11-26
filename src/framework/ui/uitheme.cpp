#include "uitheme.h"

#include <QFontDatabase>

using namespace gs::ui;

UiTheme::UiTheme(QObject* parent) : QObject(parent)
{
    init();
}

void UiTheme::init()
{
    initFonts();
}

void UiTheme::initFonts()
{
    QFontDatabase::addApplicationFont(":/fonts/Inter.ttf");
    QFontDatabase::addApplicationFont(":/fonts/bootstrap-icons.woff2");
}

void UiTheme::loadTheme(const QString& file)
{
}

void UiTheme::update()
{
}

bool UiTheme::isDark() const
{
    return m_isDark;
}

void UiTheme::setIsDark(bool isDark)
{
    if (m_isDark == isDark) {
        return;
    }

    m_isDark = isDark;
    emit themeChanged();
}

QColor UiTheme::accentColor() const
{
    return m_accentColor;
}

void UiTheme::setAccentColor(QColor accentColor)
{
    if (m_accentColor == accentColor) {
        return;
    }

    m_accentColor = accentColor;
    emit themeChanged();
}

QColor UiTheme::backgroundPrimaryColor() const
{
    return m_backgroundPrimaryColor;
}

void UiTheme::setBackgroundPrimaryColor(QColor backgroundPrimaryColor)
{
    if (m_backgroundPrimaryColor == backgroundPrimaryColor) {
        return;
    }

    m_backgroundPrimaryColor = backgroundPrimaryColor;
    emit themeChanged();
}

QColor UiTheme::backgroundSecondaryColor() const
{
    return m_backgroundSecondaryColor;
}

void UiTheme::setBackgroundSecondaryColor(QColor backgroundSecondaryColor)
{
    if (m_backgroundSecondaryColor == backgroundSecondaryColor) {
        return;
    }

    m_backgroundSecondaryColor = backgroundSecondaryColor;
    emit themeChanged();
}

QColor UiTheme::buttonColor() const
{
    return m_buttonColor;
}

void UiTheme::setButtonColor(QColor buttonColor)
{
    if (m_buttonColor == buttonColor) {
        return;
    }

    m_buttonColor = buttonColor;
    emit themeChanged();
}

QColor UiTheme::componentColor() const
{
    return m_componentColor;
}

void UiTheme::setComponentColor(QColor componentColor)
{
    if (m_componentColor == componentColor) {
        return;
    }

    m_componentColor = componentColor;
    emit themeChanged();
}

QColor UiTheme::focusColor() const
{
    return m_focusColor;
}

void UiTheme::setFocusColor(QColor focusColor)
{
    if (m_focusColor == focusColor) {
        return;
    }

    m_focusColor = focusColor;
    emit themeChanged();
}

QColor UiTheme::fontPrimaryColor() const
{
    return m_fontPrimaryColor;
}

void UiTheme::setFontPrimaryColor(QColor fontPrimaryColor)
{
    if (m_fontPrimaryColor == fontPrimaryColor) {
        return;
    }

    m_fontPrimaryColor = fontPrimaryColor;
    emit themeChanged();
}

QColor UiTheme::fontSecondaryColor() const
{
    return m_fontSecondaryColor;
}

void UiTheme::setFontSecondaryColor(QColor fontSecondaryColor)
{
    if (m_fontSecondaryColor == fontSecondaryColor) {
        return;
    }

    m_fontSecondaryColor = fontSecondaryColor;
    emit themeChanged();
}

QColor UiTheme::linkColor() const
{
    return m_linkColor;
}

void UiTheme::setLinkColor(QColor linkColor)
{
    if (m_linkColor == linkColor) {
        return;
    }

    m_linkColor = linkColor;
    emit themeChanged();
}

QColor UiTheme::popupBackgroundColor() const
{
    return m_popupBackgroundColor;
}

void UiTheme::setPopupBackgroundColor(QColor popupBackgroundColor)
{
    if (m_popupBackgroundColor == popupBackgroundColor) {
        return;
    }

    m_popupBackgroundColor = popupBackgroundColor;
    emit themeChanged();
}

QColor UiTheme::strokeColor() const
{
    return m_strokeColor;
}

void UiTheme::setStrokeColor(QColor strokeColor)
{
    if (m_strokeColor == strokeColor) {
        return;
    }

    m_strokeColor = strokeColor;
    emit themeChanged();
}

QFont UiTheme::bodyFont() const
{
    return m_bodyFont;
}

void UiTheme::setBodyFont(QFont bodyFont)
{
    if (m_bodyFont == bodyFont) {
        return;
    }

    m_bodyFont = bodyFont;
    emit themeChanged();
}

QFont UiTheme::bodyBoldFont() const
{
    return m_bodyBoldFont;
}

void UiTheme::setBodyBoldFont(QFont bodyBoldFont)
{
    if (m_bodyBoldFont == bodyBoldFont) {
        return;
    }

    m_bodyBoldFont = bodyBoldFont;
    emit themeChanged();
}

QFont UiTheme::headerFont() const
{
    return m_headerFont;
}

void UiTheme::setHeaderFont(QFont headerFont)
{
    if (m_headerFont == headerFont) {
        return;
    }

    m_headerFont = headerFont;
    emit themeChanged();
}

QFont UiTheme::titleFont() const
{
    return m_titleFont;
}

void UiTheme::setTitleFont(QFont titleFont)
{
    if (m_titleFont == titleFont) {
        return;
    }

    m_titleFont = titleFont;
    emit themeChanged();
}

QFont UiTheme::iconFont() const
{
    return m_iconFont;
}

void UiTheme::setIconFont(QFont iconFont)
{
    if (m_iconFont == iconFont) {
        return;
    }

    m_iconFont = iconFont;
    emit themeChanged();
}

QVector2D UiTheme::defaultButtonSize() const
{
    return m_defaultButtonSize;
}

void UiTheme::setDefaultButtonSize(QVector2D buttonSize)
{
    if (m_defaultButtonSize == buttonSize) {
        return;
    }

    m_defaultButtonSize = buttonSize;
    emit themeChanged();
}

QVector2D UiTheme::defaultComponentSize() const
{
    return m_defaultComponentSize;
}

void UiTheme::setDefaultComponentSize(QVector2D componentSize)
{
    if (m_defaultComponentSize == componentSize) {
        return;
    }

    m_defaultComponentSize = componentSize;
    emit themeChanged();
}
