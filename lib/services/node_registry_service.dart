import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_output.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/models/nodes.dart';
import 'package:gimelstudio/services/id_service.dart';

class NodeRegistryService {
  final _idService = locator<IdService>();

  // TODO: could also define the nodes in a separate file
  // and load each with a registerNode method.

  // ignore: prefer_final_fields
  Map<String, NodeBase> _nodeRegistry = {
    'integer_corenode': IntegerNode(
      properties: {
        'number': IntegerProperty(name: 'number', dataType: int, value: 21),
      },
      outputs: {
        'output': Output(name: 'output', dataType: int),
      },
    ),
    'add_corenode': AddNode(
      properties: {
        'a': IntegerProperty(name: 'a', dataType: int, value: 0),
        'b': IntegerProperty(name: 'b', dataType: int, value: 0),
      },
      outputs: {
        'output': Output(name: 'output', dataType: int),
      },
    ),
    'output_corenode': OutputNode(
      properties: {
        'final': IntegerProperty(name: 'final', dataType: int, value: 10),
      },
      outputs: {},
    ),
    'output2_corenode': OutputNode(
      properties: {
        'final': IntegerProperty(name: 'final', dataType: int, value: 10),
      },
      outputs: {},
    ),
  };
  Map<String, NodeBase> get nodeRegistry => _nodeRegistry;

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
