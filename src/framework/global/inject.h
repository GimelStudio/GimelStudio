#ifndef GS_GLOBAL_INJECT_H
#define GS_GLOBAL_INJECT_H

// This macro can only be used if the class supplies its own instance method
#define INJECT_CLASS_INSTANCE(_Class, _name) \
private: \
    _Class* _name() \
    { \
        return _Class::instance(); \
    }

// Use this as a shorter way to add an instance method to a class
#define INJECT_INSTANCE_METHOD(_Class) \
public: \
    static _Class* instance() \
    { \
        static _Class cls; \
        return &cls; \
    }

#define INJECT_PROPERTY(_Type, _name, _getter, _setter) \
public: \
    _Type _getter() { return m_##_name; } \
    void _setter(_Type val) { m_##_name = val; } \
private: \
    _Type m_##_name;

#endif // GS_GLOBAL_INJECT_H
