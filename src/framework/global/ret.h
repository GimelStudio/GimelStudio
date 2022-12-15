#ifndef GS_GLOBAL_RET_H
#define GS_GLOBAL_RET_H

#include <any>
#include <map>
#include <string>

#include <QObject>
#include <QMetaType>

#include "types/string.h"

using namespace gs::types;

namespace gs
{
class Ret
{
public:
    enum class Code {
        Undefined = -1,
        Ok = 0,
        Cancel = 1,
        UnknownError = 2,
        NotSupported = 3,
        NotImplemented = 4,
        Bug = 5
    };

    Ret() = default;
    explicit Ret(int c);
    explicit Ret(Code c);
    explicit Ret(const int& c, const String& text);

    inline Ret& operator=(int c) { m_code = c; return *this; }
    inline Ret& operator=(bool arg) { m_code = arg ? int(Code::Ok) : int(Code::UnknownError); return *this; }
    inline operator bool() const {
        return isSuccess();
    }
    inline bool operator!() const { return !isSuccess(); }

    int code() const;
    void setCode(int c);
    bool isValid() const;
    bool isSuccess() const;
    const String& text() const;
    void setText(const String& s);
    std::any data(const String& key);
    void setData(const String& key, const std::any& val);
private:
    int m_code = static_cast<int>(Code::Undefined);
    String m_text;
    std::map<String, std::any> m_data;
};
}

#endif
