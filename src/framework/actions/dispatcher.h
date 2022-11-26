#ifndef GS_ACTIONS_DISPATCHER_H
#define GS_ACTIONS_DISPATCHER_H

#include "internal/dispatcher.h"

using namespace gs::actions;

static Dispatcher* dispatcher()
{
    return Dispatcher::instance();
}

#endif
