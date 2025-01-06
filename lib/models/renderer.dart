import 'package:gimelstudio/models/eval_info.dart';
import 'package:gimelstudio/models/node_base.dart';

class Renderer {
  Renderer({
    required this.nodes,
  });

  final Map<String, NodeBase> nodes;

  int render(String outputNodeId) {
    NodeBase outputNode = getOutputNode(outputNodeId);
    print('${outputNode.idname} connection -> ${outputNode.properties['final']?.connection}');

    // The node that is connected to this output node.
    NodeBase? nodeConnectedToOutput = outputNode.connectedNode?.$1;
    // The name of the output of the node connected to this output node.
    String? connectedOutputName = outputNode.connectedNode?.$2;

    if (nodeConnectedToOutput == null || connectedOutputName == null) {
      // No node is connected to the output node.
      return -1;
    }

    EvalInfo evalInfo = EvalInfo(node: nodeConnectedToOutput);
    int result = evalInfo.node.evaluateNode(evalInfo)[connectedOutputName];

    return result;
  }

  NodeBase getOutputNode(String outputNodeId) {
    NodeBase? outputNode;
    for (String key in nodes.keys) {
      if (nodes[key]?.isOutput == true && outputNodeId == key) {
        outputNode = nodes[key];
      }
    }
    assert(outputNode != null);
    return outputNode!;
  }
}
