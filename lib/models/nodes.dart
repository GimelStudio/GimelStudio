import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart' as item;
import 'package:gimelstudio/models/eval_info.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';

class IntegerNode extends NodeBase {
  IntegerNode({
    super.id = '',
    super.idname = 'integer_corenode',
    super.isOutput = false,
    super.label = 'Integer',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  Map<String, int> evaluateNode(EvalInfo eval) {
    int number = eval.evaluateProperty('number');
    return {
      'output': number,
    };
  }

  factory IntegerNode.clone(NodeBase source, String id) {
    return IntegerNode(
      id: id,
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

class RectangleNode extends NodeBase {
  RectangleNode({
    super.id = '',
    super.idname = 'rectangle_corenode',
    super.isOutput = false,
    super.label = 'Rectangle',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  Map<String, item.Rectangle> evaluateNode(EvalInfo eval) {
    // TODO: For now this uses integers, but it should use doubles to avoid
    // the need to convert to doubles.
    int x = eval.evaluateProperty('x');
    int y = eval.evaluateProperty('y');
    int width = eval.evaluateProperty('width');
    int height = eval.evaluateProperty('height');
    item.CanvasItemFill fill = eval.evaluateProperty('fill');

    return {
      'output': item.Rectangle(
        opacity: 100,
        blendMode: BlendMode.srcOver,
        x: x.toDouble(),
        y: y.toDouble(),
        width: width.toDouble(),
        height: height.toDouble(),
        fill: fill,
      ),
    };
  }

  factory RectangleNode.clone(NodeBase source, String id) {
    return RectangleNode(
      id: id,
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

class TextNode extends NodeBase {
  TextNode({
    super.id = '',
    super.idname = 'text_corenode',
    super.isOutput = false,
    super.label = 'Text',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  Map<String, item.Text> evaluateNode(EvalInfo eval) {
    int x = eval.evaluateProperty('x');
    int y = eval.evaluateProperty('y');
    int width = eval.evaluateProperty('width');
    int height = eval.evaluateProperty('height');
    // String text = eval.evaluateProperty('text'); // TODO
    item.CanvasItemFill fill = eval.evaluateProperty('fill');
    int size = eval.evaluateProperty('size');
    int letterSpacing = eval.evaluateProperty('letter_spacing');

    return {
      'output': item.Text(
        opacity: 100,
        blendMode: BlendMode.srcOver,
        x: x.toDouble(),
        y: y.toDouble(),
        width: width.toDouble(),
        height: height.toDouble(),
        text: 'Example text',
        fill: fill,
        border: item.CanvasItemBorder(thickness: 1.0),
        font: '',
        size: size.toDouble(),
        letterSpacing: letterSpacing.toDouble(),
        lineSpacing: 1.0,
      ),
    };
  }

  factory TextNode.clone(NodeBase source, String id) {
    return TextNode(
      id: id,
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

class AddNode extends NodeBase {
  AddNode({
    super.id = '',
    super.idname = 'add_corenode',
    super.isOutput = false,
    super.label = 'Add',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  Map<String, int> evaluateNode(EvalInfo eval) {
    int inputA = evaluateProperty(eval, 'a');
    int inputB = evaluateProperty(eval, 'b');

    return {
      'output': inputA + inputB,
    };
  }

  factory AddNode.clone(NodeBase source, String id) {
    return AddNode(
      id: id,
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

class OutputNode extends NodeBase {
  OutputNode({
    super.id = '',
    super.idname = 'output_corenode',
    super.isOutput = true,
    super.label = 'Output',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  (NodeBase, String)? get connectedNode {
    Property prop = properties.values.firstWhere((item) => item.idname == 'layer');
    return prop.connection;
  }

  factory OutputNode.clone(NodeBase source, String id) {
    return OutputNode(
      id: id,
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

class OutputNode2 extends NodeBase {
  OutputNode2({
    super.id = '',
    super.idname = 'output2_corenode',
    super.isOutput = true,
    super.label = 'Output2',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  (NodeBase, String)? get connectedNode {
    Property prop = properties.values.firstWhere((item) => item.idname == 'layer');
    return prop.connection;
  }

  factory OutputNode2.clone(NodeBase source, String id) {
    return OutputNode2(
      id: id,
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
