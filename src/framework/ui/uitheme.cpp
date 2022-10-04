#include "uitheme.h"

using namespace gs::ui;

void UiTheme::init()
{
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
