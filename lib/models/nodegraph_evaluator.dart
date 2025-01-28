import 'package:gimelstudio/models/eval_info.dart';
import 'package:gimelstudio/models/node_base.dart';

class NodeGraphEvaluator {
  NodeGraphEvaluator({
    required this.nodes,
  });

  final Map<String, Node> nodes;

  dynamic evaluate(String outputNodeIdname) {
    Node outputNode = getOutputNode(outputNodeIdname);
    //print('${outputNode.idname} connection -> ${outputNode.properties['layer']?.connection}');

    // The node that is connected to this output node.
    Node? nodeConnectedToOutput = outputNode.connectedNode?.$1;
    // The name of the output of the node connected to this output node.
    String? connectedOutputIdname = outputNode.connectedNode?.$2;

    if (nodeConnectedToOutput == null || connectedOutputIdname == null) {
      // No node is connected to the output node.
      print('No node is connected to the output node. $nodeConnectedToOutput | $connectedOutputIdname');
      return -1;
    }

    EvalInfo evalInfo = EvalInfo(node: nodeConnectedToOutput);
    dynamic result = evalInfo.node.evaluateNode(evalInfo)[connectedOutputIdname];

    return result;
  }

  Node getOutputNode(String outputNodeIdname) {
    Node? outputNode;
    for (String key in nodes.keys) {
      if (nodes[key]?.isOutput == true && nodes[key]?.idname == outputNodeIdname) {
        outputNode = nodes[key];
      }
    }
    assert(outputNode != null);
    return outputNode!;
  }
}
