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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nodes': {for (NodeBase node in nodes.values) node.id: node.toJson()}
    };
  }

  NodeGraph.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nodes = {for (Map<String, dynamic> node in json['nodes']) node['id']: NodeBase.fromJson(node)};

  @override
  String toString() {
    return 'id: $id, nodes: $nodes';
  }
}
