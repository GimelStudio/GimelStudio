import 'package:gimelstudio/models/node_base.dart';

class NodeGraph {
  NodeGraph({
    required this.id,
    required this.nodes,
  });

  final String id;
  Map<String, NodeBase> nodes;

  // void initDefault() {
  //   nodes = {};
  // }

  void addNode(String id, NodeBase node) {
    nodes[id] = node;
  }

  void removeNode(NodeBase node) {
    nodes.remove(node);
  }

  @override
  String toString() {
    return 'id: $id, nodes: $nodes';
  }
}
