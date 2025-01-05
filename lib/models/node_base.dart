import 'package:flutter/widgets.dart';
import 'package:gimelstudio/models/eval_info.dart';
import 'package:gimelstudio/models/node_output.dart';
import 'package:gimelstudio/models/node_property.dart';

/// The base class for all nodes.
class NodeBase {
  NodeBase({
    this.id = '', // Will be assigned when created in the node graph.
    required this.idname,
    required this.isOutput,
    this.label = '...',
    this.selected = false,
    required this.properties,
    required this.outputs,
    this.position = const Offset(10, 10),
  });

  /// A unique id.
  String id;

  /// The string by which the node type will be referenced.
  /// This should be unique among all nodes.
  /// Example: 'integer_node'
  final String idname;

  /// Whether this node is the output node in the node graph.
  final bool isOutput;

  /// The node's displayed label.
  String label;

  /// Properties
  Map<String, Property> properties;

  /// Outputs
  Map<String, Output> outputs;

  /// The (x, y) position of the node in the node graph.
  Offset position;

  /// Whether this node is selected in the node graph.
  bool selected;

  //PhosphorIconData icon = PhosphorIcons.notepad(PhosphorIconsStyle.light);

  /// Use for the output node only.
  (NodeBase, String)? get connectedNode {
    return null;
  }

  void setPropertyValue(String name, Object newValue) {
    Property? property = properties[name];
    assert(property != null);
    property?.setValue(newValue);
  }

  void setConnection(String name, NodeBase connectedNode, String connectedNodeOutputName) {
    Property? property = properties[name];
    assert(property != null);
    property?.setConnection((connectedNode, connectedNodeOutputName));
  }

  dynamic evaluateProperty(EvalInfo eval, String id) {
    return eval.evaluateProperty(id);
  }

  Map<String, dynamic> evaluateNode(EvalInfo eval) {
    return {};
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idname': idname,
      'isOutput': isOutput,
      'label': label,
      'selected': selected,
      'properties': {for (Property property in properties.values) property.id: property.toJson()},
      'outputs': {}, // outputs, // TODO
      'position': [position.dx, position.dy],
    };
  }

  NodeBase.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idname = json['idname'],
        isOutput = json['isOutput'],
        label = json['label'],
        selected = json['selected'],
        properties = json['properties'], // TODO
        outputs = json['outputs'], // TODO
        position = Offset(json['position'][0], json['position'][1]);

  @override
  String toString() {
    return 'id: $id, idname: $idname, isOutput: $isOutput, label: $label, selected: $selected, properties: $properties, outputs: $outputs, position: (${position.dx}x${position.dy})';
  }

  factory NodeBase.clone(NodeBase source) {
    return NodeBase(
      id: source.id,
      idname: source.idname,
      isOutput: source.isOutput,
      label: source.label,
      selected: source.selected,
      properties: source.properties,
      outputs: source.outputs,
      position: source.position,
    );
  }
}
