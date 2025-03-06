import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_output.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/models/nodes.dart';
import 'package:gimelstudio/models/photo.dart';
import 'package:gimelstudio/services/id_service.dart';

class NodeRegistryService {
  final _idService = locator<IdService>();

  Map<String, Node> _nodeRegistry = {};
  Map<String, Node> get nodeRegistry => _nodeRegistry;

  void registerNodeType(Node node) {
    if (_nodeRegistry.keys.contains(node.idname)) {
      throw Exception('Node with idname ${node.idname} has already been registered.');
    } else {
      _nodeRegistry[node.idname] = node;
    }
  }

  Node createNode(String idname, Offset position) {
    // Create a new node object.
    Node node;
    Node protoNode = nodeRegistry.values.firstWhere((item) => item.idname == idname);
    String newNodeId = _idService.newId();

    // TODO: find a way to register nodes without being so verbose.
    switch (idname) {
      case 'integer_corenode':
        node = IntegerNode.clone(protoNode, newNodeId);
      case 'double_corenode':
        node = DoubleNode.clone(protoNode, newNodeId);
      case 'rectangle_corenode':
        node = RectangleNode.clone(protoNode, newNodeId);
      case 'text_corenode':
        node = TextNode.clone(protoNode, newNodeId);
      case 'image_corenode':
        node = ImageNode.clone(protoNode, newNodeId);
      case 'photo_corenode':
        node = PhotoNode.clone(protoNode, newNodeId);
      case 'blur_corenode':
        node = BlurNode.clone(protoNode, newNodeId);
      case 'add_corenode':
        node = AddNode.clone(protoNode, newNodeId);
      case 'output_corenode':
        node = OutputNode.clone(protoNode, newNodeId);
      default:
        throw ('No node in the registry with the specified idname, $idname');
    }

    // Set the position.
    node.position = position;

    Map<String, Property> protoProperties = node.properties;
    Map<String, Output> protoOutputs = node.outputs;

    // Re-create the properties and outputs for the node type.
    node.properties = {};
    for (Property property in protoProperties.values) {
      Property newProperty;
      String newPropertyId = _idService.newId();
      switch (property.dataType) {
        case int:
          newProperty = IntegerProperty.clone(property, newPropertyId);
        case double:
          newProperty = DoubleProperty.clone(property, newPropertyId);
        case bool:
          newProperty = BooleanProperty.clone(property, newPropertyId);
        case String:
          newProperty = TextProperty.clone(property, newPropertyId);
        case Photo:
          newProperty = PhotoProperty.clone(property, newPropertyId);
        case CanvasItem:
          newProperty = CanvasItemProperty.clone(property, newPropertyId);
        case CanvasItemFill:
          newProperty = CanvasItemFillProperty.clone(property, newPropertyId);
        case CanvasItemBorder:
          newProperty = CanvasItemBorderProperty.clone(property, newPropertyId);
        case CanvasItemBorderRadius:
          newProperty = CanvasItemBorderRadiusProperty.clone(property, newPropertyId);
        default:
          throw ('Property for datatype ${property.dataType} was not registered. Did you forget to register it?');
      }
      node.properties[property.idname] = newProperty;
    }

    node.outputs = {};
    for (Output output in protoOutputs.values) {
      String newOutputId = _idService.newId();
      node.outputs[output.idname] = Output.clone(output, newOutputId);
    }

    return node;
  }

  Map<String, Node> newDefaultNodes(String type, String outputLabel) {
    Map<String, Node> defaultNodes = {};

    if (type == 'rectangle') {
      Node rectangleNode = createNode('rectangle_corenode', Offset(200, 80));
      rectangleNode.selected = true;
      defaultNodes[rectangleNode.id] = rectangleNode;
    } else if (type == 'image') {
      Node photoNode = createNode('photo_corenode', Offset(100, 80));
      defaultNodes[photoNode.id] = photoNode;

      // Node blurNode = createNode('blur_corenode', Offset(110, 80));
      // defaultNodes[blurNode.id] = blurNode;

      Node imageNode = createNode('image_corenode', Offset(250, 80));
      imageNode.selected = true;
      defaultNodes[imageNode.id] = imageNode;
    } else if (type == 'text') {
      Node textNode = createNode('text_corenode', Offset(300, 80));
      textNode.selected = true;
      defaultNodes[textNode.id] = textNode;
    }

    Node outputNode = createNode('output_corenode', Offset(410, 80));
    defaultNodes[outputNode.id] = outputNode;
    outputNode.label = outputLabel; // TODO: need to keep this in sync with the layer name

    return defaultNodes;
  }
}
