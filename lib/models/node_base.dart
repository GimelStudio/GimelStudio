import 'package:flutter/widgets.dart';
import 'package:gimelstudio/models/eval_info.dart';
import 'package:gimelstudio/models/node_output.dart';
import 'package:gimelstudio/models/node_property.dart';

/// The base class for all nodes.
class NodeBase {
  NodeBase({
    required this.name,
  }) {
    defineMeta();
    defineProperties();
    defineOutputs();
  }

  /// The string by which the node type will be referenced.
  /// This should be unique among all nodes.
  final String name;

  String label = '...';
  //PhosphorIconData icon = PhosphorIcons.notepad(PhosphorIconsStyle.light);
  Offset position = const Offset(0, 0);
  bool selected = false;

  Map<String, Property> properties = {};
  Map<String, Output> outputs = {};

  bool isOutput() {
    return false;
  }

  /// Use for the output node only.
  (NodeBase, String)? get connectedNode {
    return null;
  }

  void defineMeta() {}

  void defineProperties() {
    properties = {};
  }

  void defineOutputs() {
    outputs = {};
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
}
