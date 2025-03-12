import 'dart:ui';
import 'package:gimelstudio/models/eval_info.dart';
import 'package:gimelstudio/models/node_categories.dart';
import 'package:gimelstudio/models/node_output.dart';
import 'package:gimelstudio/models/node_property.dart';

/// The base class for defining all nodes.
class Node {
  Node({
    this.id = '', // Id will be assigned when created in the node graph.
    required this.idname,
    required this.category,
    this.label = '...',
    this.selected = false,
    required this.properties,
    required this.outputs,
    this.size = const Size(130.0, 36.0),
    this.position = const Offset(10.0, 10.0),
  });

  /// A unique id.
  String id;

  /// The string by which the node type will be referenced.
  /// This should be unique among all nodes.
  /// Example: 'integer_node'
  final String idname;

  /// The category that this node belongs to.
  final NodeCategory category;

  /// The node's displayed label.
  String label;

  /// Whether this node is selected in the node graph.
  bool selected;

  /// Properties
  Map<String, Property> properties;

  /// Outputs
  Map<String, Output> outputs;

  /// The (w, h) size of the node in the node graph.
  Size size;

  /// The (x, y) position of the node in the node graph.
  Offset position;

  //PhosphorIconData icon = PhosphorIcons.notepad(PhosphorIconsStyle.light);

  /// Whether this node is the output node in the node graph.
  bool get isLayerOutput => false;

  /// Whether this node is a Canvas Item node (a node that returns a CanvasItem).
  bool get isCanvasItemNode => false;

  /// Use for the output node only.
  (Node, String)? get connectedNode {
    return null;
  }

  /// Get the node category color
  Color get categoryColor {
    return nodeDatatypeColors[category]!;
  }

  Property getPropertyByIdname(String idname) {
    return properties.values.firstWhere((item) => item.idname == idname);
  }

  void setPropertyValue(String idname, Object newValue) {
    Property property = getPropertyByIdname(idname);
    property.setValue(newValue);
  }

  void setConnection(String idname, Node connectedNode, String connectedNodeOutputName) {
    Property property = getPropertyByIdname(idname);
    property.setConnection((connectedNode, connectedNodeOutputName));
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
      'label': label,
      'selected': selected,
      'properties': {for (Property property in properties.values) property.idname: property.toJson()},
      'outputs': {for (Output output in outputs.values) output.idname: output.toJson()},
      'size': [size.width, size.height],
      'position': [position.dx, position.dy],
    };
  }

  Node.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        idname = json['idname'] as String,
        category = json['category'], // TODO
        label = json['label'] as String,
        selected = json['selected'] as bool,
        properties = {
          for (Map<String, dynamic> property in json['properties'])
            property['idname'] as String: Property.fromJson(property)
        },
        outputs = {
          for (Map<String, dynamic> output in json['outputs']) json['idname'] as String: Output.fromJson(output)
        },
        size = Size(json['size'][0] as double, json['size'][1] as double),
        position = Offset(json['position'][0] as double, json['position'][1] as double);

  @override
  String toString() {
    return 'Node{id: $id, idname: $idname, isLayerOutput: $isLayerOutput, label: $label, selected: $selected, properties: $properties, outputs: $outputs, size: (${size.width}, ${size.height}), position: (${position.dx}, ${position.dy})}';
  }
}
