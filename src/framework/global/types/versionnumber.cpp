#include "versionnumber.h"

using namespace gs::types;

VersionNumber::VersionNumber() {}

VersionNumber::VersionNumber(int majorVersion)
{
    m_majorVersion = majorVersion;
}

VersionNumber::VersionNumber(int majorVersion, int minorVersion)
{
    m_majorVersion = majorVersion;
    m_minorVersion = minorVersion;
}

VersionNumber::VersionNumber(int majorVersion, int minorVersion, int microVersion)
{
    m_majorVersion = majorVersion;
    m_minorVersion = minorVersion;
    m_microVersion = microVersion;
}

VersionNumber::VersionNumber(int majorVersion, int minorVersion, int microVersion, int tag)
{
    m_majorVersion = majorVersion;
    m_minorVersion = minorVersion;
    m_microVersion = microVersion;
    m_tag = tag;
}

bool VersionNumber::operator==(const VersionNumber &other)
{
    return majorVersion() == other.majorVersion() &&
            minorVersion() == other.minorVersion() &&
            microVersion() == other.microVersion() &&
            tag() == other.tag();
}

bool VersionNumber::operator!=(const VersionNumber &other)
{
    return majorVersion() != other.majorVersion() ||
            minorVersion() != other.minorVersion() ||
            microVersion() != other.microVersion() ||
            tag() != other.tag();
}

int VersionNumber::majorVersion() const 
{
    return m_majorVersion;
}

void VersionNumber::setMajorVersion(int val)
{
    m_majorVersion = val;
}

int VersionNumber::minorVersion() const
{
    return m_minorVersion;
}

void VersionNumber::setMinorVersion(int val)
{
    m_minorVersion = val;
}

int VersionNumber::microVersion() const
{
    return m_microVersion;
}

void VersionNumber::setMicroVersion(int val)
{
    m_microVersion = val;
}

int VersionNumber::tag() const
{
    return m_tag;
}

void VersionNumber::setTag(int val)
{
    m_tag = val;
}
