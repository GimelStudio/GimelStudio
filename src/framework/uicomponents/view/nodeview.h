#ifndef GS_UICOMPONENTS_NODEVIEW_H
#define GS_UICOMPONENTS_NODEVIEW_H

#include "nodes/node.h"

#include <QObject>
#include <QQuickItem>

using namespace gs::nodes;

namespace gs::uicomponents {
class NodeView : public QQuickItem, public Node
{
    Q_OBJECT
public:
    NodeView(QQuickItem *parent = 0);

    void buildUi();
};
}

#endif // GS_UICOMPONENTS_NODEVIEW_H
