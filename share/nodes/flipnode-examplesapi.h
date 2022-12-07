// Use this for the built-in nodes
#include "uicomponents/view/node.h"

// Use this instead for thirdparty nodes
// #include "gimelstudio/node.h"

using namespace gs::uicomponents;
// using namespace gs::api;

class FlipNode : public Node
{
public:
    explicit FlipNode();
    ~FlipNode() override = default;

    QVariantMap metaData() override;
    void initInputProperties() override;
    void initOutputProperties() override;
    void mutedEvaluation() override;
    void evaluation() override;
}
