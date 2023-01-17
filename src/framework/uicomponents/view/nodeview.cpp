#include "nodeview.h"

#include "nodes/iproperty.h"
#include "propertyview.h"

using namespace gs::uicomponents;

NodeView::NodeView(QQuickItem *parent) : QQuickItem(parent)
{
    buildUi();
}

void NodeView::buildUi()
{
    for (IProperty* property : inputProperties()) {
        std::cout << property->name() << std::endl;
    }
}
