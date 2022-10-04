#include "uiengines.h"

QQmlEngine* qmlEngine()
{
    static QQmlEngine engine;
    return &engine;
}

QQmlApplicationEngine* qmlAppEngine()
{
    static QQmlApplicationEngine engine;
    return &engine;
}
