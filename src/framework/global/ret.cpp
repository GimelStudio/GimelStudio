#include "ret.h"

using namespace gs;

Ret::Ret(int c) : m_code(c)
{}

Ret::Ret(Code c) : m_code(static_cast<int>(c))
{}

Ret::Ret(const int& c, const String& text) : m_code(c), m_text(text)
{}

int Ret::code() const
{
    return m_code;
}

void Ret::setCode(int c)
{
    m_code = c;
}

bool Ret::isValid() const
{
    return m_code > static_cast<int>(Code::Undefined);
}

bool Ret::isSuccess() const
{
    return m_code == static_cast<int>(Code::Ok);
}

const String& Ret::text() const
{
    return m_text;
}

void Ret::setText(const String& s)
{
    m_text = s;
}

std::any Ret::data(const String& s)
{
    auto it = m_data.find(s);
    if (it != m_data.end()) {
        return it->second;
    }

    return std::any();
}

void Ret::setData(const String& key, const std::any& val)
{
    m_data[key] = val;
}
