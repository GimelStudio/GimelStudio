
#ifndef GS_NODES_NODETREE_H
#define GS_NODES_NODETREE_H

#include "node.h"

#include "types/list.h"

class NodeTree
{
private:
    Node* m_inputNode;
    Node* m_outputNode;
    List<Node*> m_nodes;
public:
    void addNode(Node* n);
    void evaluate();

    Node* inputNode();
    void setInputNode(Node* n);

    Node* outputNode();
    void setOutputNode(Node* n);
};

#endif // GS_NODES_NODETREE_H
