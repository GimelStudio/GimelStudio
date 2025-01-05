import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/services/id_service.dart';

class NodeRegistryService {
  final _idService = locator<IdService>();

  Map<String, NodeBase> _nodeRegistry = {};
  Map<String, NodeBase> get nodeRegistry => _nodeRegistry;

  void registerNodeType(NodeBase node) {
    if (_nodeRegistry.keys.contains(node.idname)) {
      throw Exception('Node with idname ${node.idname} has already been registered.');
    } else {
      _nodeRegistry[node.idname] = node;
    }
  }

  NodeBase createNode(String idname, Offset position) {
    // Create a new node object.
    NodeBase node = NodeBase.clone(nodeRegistry.values.firstWhere((item) => item.idname == idname));
    // Assign an id to the node.
    node.id = _idService.newId();
    // Set the position.
    node.position = position;
    return node;
  }
}
