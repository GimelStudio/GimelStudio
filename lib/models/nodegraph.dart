import 'package:gimelstudio/models/node_base.dart';

class NodeGraph {
  NodeGraph({
    required this.id,
    required this.nodes,
  });

  final int id; // TODO: use uuid
  Map<String, NodeBase> nodes;
}
