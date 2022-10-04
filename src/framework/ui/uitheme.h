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
    Q_PROPERTY(QColor backgroundColor READ backgroundColor WRITE setBackgroundColor NOTIFY themeChanged)
    Q_PROPERTY(QColor componentColor READ componentColor WRITE setComponentColor NOTIFY themeChanged)
    Q_PROPERTY(QColor fontPrimaryColor READ fontPrimaryColor WRITE setFontPrimaryColor NOTIFY themeChanged)
    Q_PROPERTY(QColor fontSecondaryColor READ fontSecondaryColor WRITE setFontSecondaryColor NOTIFY themeChanged)
    Q_PROPERTY(QColor linkColor READ linkColor WRITE setLinkColor NOTIFY themeChanged)

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

    QColor backgroundColor() const;
    void setBackgroundColor(QColor backgroundColor);

    QColor componentColor() const;
    void setComponentColor(QColor componentColor);

    QColor fontPrimaryColor() const;
    void setFontPrimaryColor(QColor fontPrimaryColor);

    QColor fontSecondaryColor() const;
    void setFontSecondaryColor(QColor fontSecondaryColor);

    QColor linkColor() const;
    void setLinkColor(QColor linkColor);

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
    QColor m_accentColor = "#448AFF";
    QColor m_backgroundColor = "#EEEEEE";
    QColor m_componentColor = "#BDBDBD";
    QColor m_fontPrimaryColor = "#292929";
    QColor m_fontSecondaryColor = "#757575";
    QColor m_linkColor = "#448AFF";

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
