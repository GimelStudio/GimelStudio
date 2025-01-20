import 'package:gimelstudio/models/node_base.dart';

class NodeGraph {
  NodeGraph({
    required this.id,
    required this.nodes,
  });

  final String id;
  Map<String, Node> nodes;

  // void initDefault() {
  //   nodes = {};
  // }

  void addNode(String id, Node node) {
    nodes[id] = node;
  }

  void removeNode(Node node) {
    nodes.remove(node);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nodes': {for (Node node in nodes.values) node.id: node.toJson()}
    };
  }

  NodeGraph.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nodes = {for (Map<String, dynamic> node in json['nodes']) node['id']: Node.fromJson(node)};

  @override
  String toString() {
    return 'id: $id, nodes: $nodes';
  }
}
