// This macro can be used for any class
#define INJECT(_Class, _name) \
private: \
    _Class* _name() \
    { \
        static _Class cls; \
        return &cls; \
    }

// This macro can only be used if the class supplies its own instance method
#define INJECT_STATIC(_Class, _name) \
private: \
    _Class* _name() \
    { \
        return _Class::instance(); \
    }

// Use this as a shorter way to add an instance method to a class
#define INJECT_INSTANCE_METHOD(_Class) \
private: \
    _Class* _name() \
    { \
        static _Class cls; \
        return &cls; \
    }
