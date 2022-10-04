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

QColor UiTheme::backgroundColor() const
{
    return m_backgroundColor;
}

void UiTheme::setBackgroundColor(QColor backgroundColor)
{
    if (m_backgroundColor == backgroundColor) {
        return;
    }

    m_backgroundColor = backgroundColor;
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
