#ifndef GS_UI_UITHEME_H
#define GS_UI_UITHEME_H

#include <QColor>
#include <QFont>
#include <QList>
#include <QObject>
#include <QVariantMap>

// TODO: Should `iuitheme.h` exist?

namespace gs::ui
{
class UiTheme : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isDark READ isDark WRITE setIsDark NOTIFY themeChanged)

    Q_PROPERTY(QColor accentColor READ accentColor WRITE setAccentColor NOTIFY themeChanged)
    Q_PROPERTY(QColor backgroundPrimaryColor READ backgroundPrimaryColor WRITE setBackgroundPrimaryColor NOTIFY themeChanged)
    Q_PROPERTY(QColor backgroundSecondaryColor READ backgroundSecondaryColor WRITE setBackgroundSecondaryColor NOTIFY themeChanged)
    Q_PROPERTY(QColor buttonColor READ buttonColor WRITE setButtonColor NOTIFY themeChanged)
    Q_PROPERTY(QColor componentColor READ componentColor WRITE setComponentColor NOTIFY themeChanged)
    Q_PROPERTY(QColor focusColor READ focusColor WRITE setFocusColor NOTIFY themeChanged)
    Q_PROPERTY(QColor fontPrimaryColor READ fontPrimaryColor WRITE setFontPrimaryColor NOTIFY themeChanged)
    Q_PROPERTY(QColor fontSecondaryColor READ fontSecondaryColor WRITE setFontSecondaryColor NOTIFY themeChanged)
    Q_PROPERTY(QColor linkColor READ linkColor WRITE setLinkColor NOTIFY themeChanged)
    Q_PROPERTY(QColor popupBackgroundColor READ popupBackgroundColor WRITE setPopupBackgroundColor NOTIFY themeChanged)
    Q_PROPERTY(QColor strokeColor READ strokeColor WRITE setStrokeColor NOTIFY themeChanged)

    Q_PROPERTY(QFont bodyFont READ bodyFont WRITE setBodyFont NOTIFY themeChanged)
    Q_PROPERTY(QFont bodyBoldFont READ bodyBoldFont WRITE setBodyBoldFont NOTIFY themeChanged)
    Q_PROPERTY(QFont headerFont READ headerFont WRITE setHeaderFont NOTIFY themeChanged)
    Q_PROPERTY(QFont titleFont READ titleFont WRITE setTitleFont NOTIFY themeChanged)

public:
    // TODO: Dynamically load the ui theme properties (either from std::map or a file)
    void init();
    // TODO: Load from a TOML file
    void loadTheme(const QString& file);
    void update();

    bool isDark() const;
    void setIsDark(bool isDark);

    QColor accentColor() const;
    void setAccentColor(QColor accentColor);

    QColor backgroundPrimaryColor() const;
    void setBackgroundPrimaryColor(QColor backgroundPrimaryColor);

    QColor backgroundSecondaryColor() const;
    void setBackgroundSecondaryColor(QColor backgroundSecondaryColor);

    QColor buttonColor() const;
    void setButtonColor(QColor buttonColor);

    QColor componentColor() const;
    void setComponentColor(QColor componentColor);

    QColor focusColor() const;
    void setFocusColor(QColor focusColor);

    QColor fontPrimaryColor() const;
    void setFontPrimaryColor(QColor fontPrimaryColor);

    QColor fontSecondaryColor() const;
    void setFontSecondaryColor(QColor fontSecondaryColor);

    QColor linkColor() const;
    void setLinkColor(QColor linkColor);

    QColor popupBackgroundColor() const;
    void setPopupBackgroundColor(QColor popupBackgroundColor);

    QColor strokeColor() const;
    void setStrokeColor(QColor strokeColor);

    QFont bodyFont() const;
    void setBodyFont(QFont bodyFont);

    QFont bodyBoldFont() const;
    void setBodyBoldFont(QFont bodyBoldFont);

    QFont headerFont() const;
    void setHeaderFont(QFont headerFont);

    QFont titleFont() const;
    void setTitleFont(QFont titleFont);

private:
    // TODO: Should this be named "UiState" instead?
    struct StyleState {
        bool enabled = false;
        bool hovered = false;
        bool pressed = false;
        bool focused = false;
    };

    QList<QVariantMap> m_themes;

    bool m_isDark;

    // See todo above init() declaration
    QColor m_accentColor = "#A4C3FF";
    QColor m_backgroundPrimaryColor = "#FFFFFF";
    QColor m_backgroundSecondaryColor = "#F3F3F3";
    QColor m_buttonColor = "#DBDBDB";
    QColor m_componentColor = "#E9E9E9";
    QColor m_focusColor = "#C2D7FF";
    QColor m_fontPrimaryColor = "#000000";
    QColor m_fontSecondaryColor = "#A5A5A5";
    QColor m_linkColor = "#0057FF";
    QColor m_popupBackgroundColor = "#F3F3F3";
    QColor m_strokeColor = "#D6D6D6";

    QFont m_bodyFont = QFont(":/fonts/inter.ttf", 12, QFont::Normal);
    QFont m_bodyBoldFont = QFont(":/fonts/inter.ttf", 12, QFont::Bold);
    QFont m_headerFont = QFont(":/fonts/inter.ttf", 16, QFont::Bold);
    QFont m_titleFont = QFont(":/fonts/inter.ttf", 32, QFont::Bold);

    // TODO: Add the rest of the ui properties

signals:
    void themeChanged();
};

static UiTheme* uitheme()
{
    // TODO: Is putting the following code in UiTheme::instance() and returning the result of UiTheme::instance() better?
    static UiTheme ut;
    return &ut;
}
}

#endif
