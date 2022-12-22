#ifndef GS_UI_UITHEME_H
#define GS_UI_UITHEME_H

#include "types/list.h"
#include "types/variant.h"
#include "types/variantmap.h"

#include <QColor>
#include <QFont>
#include <QObject>
#include <QVector2D>

// TODO: Should `iuitheme.h` exist?

using namespace gs::types;

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

    Q_PROPERTY(QFont iconFont READ iconFont WRITE setIconFont NOTIFY themeChanged)

    Q_PROPERTY(QVector2D defaultButtonSize READ defaultButtonSize WRITE setDefaultButtonSize NOTIFY themeChanged)
    Q_PROPERTY(QVector2D defaultComponentSize READ defaultComponentSize WRITE setDefaultComponentSize NOTIFY themeChanged)

public:
    // TODO: Dynamically load the ui theme properties (either from std::map or a file)
    explicit UiTheme(QObject* parent = nullptr);
    void init();
    void initFonts();
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

    QFont iconFont() const;
    void setIconFont(QFont iconFont);

    QVector2D defaultButtonSize() const;
    void setDefaultButtonSize(QVector2D buttonSize);

    QVector2D defaultComponentSize() const;
    void setDefaultComponentSize(QVector2D componentSize);

private:
    // TODO: Should this be named "UiState" instead?
    struct StyleState {
        bool enabled = false;
        bool hovered = false;
        bool pressed = false;
        bool focused = false;
    };

    List<VariantMap> m_themes;

    bool m_isDark;

    // See todo above init() declaration
    QColor m_accentColor = "#3D63C6";
    QColor m_backgroundPrimaryColor = "#E3E3E3";
    QColor m_backgroundSecondaryColor = "#D7D7D7";
    QColor m_buttonColor = "#B8BDC9";
    QColor m_componentColor = "#CFD2DA";
    QColor m_focusColor = "#9DB9FF";
    QColor m_fontPrimaryColor = "#1C1C1C";
    QColor m_fontSecondaryColor = "#A5A5A5";
    QColor m_linkColor = "#0057FF";
    QColor m_popupBackgroundColor = "#DADADA";
    QColor m_strokeColor = "#9F9F9F";

    QFont m_bodyFont = QFont("Inter", 12, QFont::Normal);
    QFont m_bodyBoldFont = QFont("Inter", 12, QFont::Bold);
    QFont m_headerFont = QFont("Inter", 16, QFont::Bold);
    QFont m_titleFont = QFont("Inter", 32, QFont::Bold);

    QFont m_iconFont = QFont("bootstrap-icons", 12);

    QVector2D m_defaultButtonSize = QVector2D(102, 30);
    QVector2D m_defaultComponentSize = QVector2D(172, 30);

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
