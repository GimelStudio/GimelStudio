import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_output.dart';
import 'package:gimelstudio/models/node_property.dart';
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
    NodeBase node = NodeBase.clone(nodeRegistry.values.firstWhere((item) => item.idname == idname), _idService.newId());
    // Set the position.
    node.position = position;

    // Re-create the properties and outputs for the node type.
    for (Property property in node.properties.values) {
      Property newProperty;
      String newPropertyId = _idService.newId();

      switch (property.dataType) {
        case int:
          newProperty = IntegerProperty.clone(property, _idService.newId());
        default:
          newProperty = IntegerProperty.clone(property, newPropertyId);
      }
      node.properties[property.idname] = newProperty;
    }

    for (Output output in node.outputs.values) {
      String newOutputId = _idService.newId();
      node.outputs[output.idname] = Output.clone(output, newOutputId);
    }

    return node;
  }
}
