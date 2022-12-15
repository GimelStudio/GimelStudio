#ifndef GS_GLOBAL_TYPES_VERSIONNUMBER_H
#define GS_GLOBAL_TYPES_VERSIONNUMBER_H

#ifdef QT_SUPPORT
#include <QMetaType>
#endif

namespace gs
{
class VersionNumber
{
private:
    int m_majorVersion = 0;
    int m_minorVersion = 0;
    int m_microVersion = 0;
    int m_tag = NONE;
public:
    bool operator==(const VersionNumber &other);
    bool operator!=(const VersionNumber &other);

    VersionNumber();
    VersionNumber(int majorVersion);
    VersionNumber(int majorVersion, int minorVersion);
    VersionNumber(int majorVersion, int minorVersion, int microVersion);
    VersionNumber(int majorVersion, int minorVersion, int microVersion, int tag);

    enum Tag {
        NONE,
        ALPHA,
        BETA,
        RELEASE_CANDIDENT
    };

    int majorVersion() const;
    void setMajorVersion(int val);

    int minorVersion() const;
    void setMinorVersion(int val);

    int microVersion() const;
    void setMicroVersion(int val);

    int tag();
    void setTag(int val);
};
}

#ifdef QT_SUPPORT
Q_DECLARE_METATYPE(VersionNumber)
#endif

#endif // GS_GLOBAL_TYPES_VERSIONNUMBER_H
