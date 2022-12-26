#include "nodetree.h"

void NodeTree::addNode(Node* n)
{
    n->initProperties();
    m_nodes.push_back(n);
}

void NodeTree::evaluate()
{
    if (m_outputNode) {
        m_outputNode->checkInputs();
        m_outputNode->evaluation();
    }
}

Node* NodeTree::inputNode()
{
    return m_inputNode;
}

void NodeTree::setInputNode(Node* n)
{
    m_inputNode = n;
}

Node* NodeTree::outputNode()
{
    return m_outputNode;
}

void NodeTree::setOutputNode(Node* n)
{
    m_outputNode = n;
}
