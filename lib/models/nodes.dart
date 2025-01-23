import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/eval_info.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/models/photo.dart';

class IntegerNode extends Node {
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

  factory IntegerNode.clone(Node source, String id) {
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

class DoubleNode extends Node {
  DoubleNode({
    super.id = '',
    super.idname = 'double_corenode',
    super.isOutput = false,
    super.label = 'Double',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  Map<String, double> evaluateNode(EvalInfo eval) {
    double number = eval.evaluateProperty('number');
    return {
      'output': number,
    };
  }

  factory DoubleNode.clone(Node source, String id) {
    return DoubleNode(
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

class RectangleNode extends Node {
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
  Map<String, CanvasRectangle> evaluateNode(EvalInfo eval) {
    double x = eval.evaluateProperty('x');
    double y = eval.evaluateProperty('y');
    double width = eval.evaluateProperty('width');
    double height = eval.evaluateProperty('height');
    CanvasItemFill fill = eval.evaluateProperty('fill');
    CanvasItemBorder border = eval.evaluateProperty('border');
    CanvasItemBorderRadius borderRadius = eval.evaluateProperty('border_radius');

    return {
      'output': CanvasRectangle(
        layerId: '',
        opacity: 100,
        blendMode: BlendMode.srcOver,
        x: x,
        y: y,
        width: width,
        height: height,
        fill: fill,
        border: border,
        borderRadius: borderRadius,
      ),
    };
  }

  factory RectangleNode.clone(Node source, String id) {
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

class TextNode extends Node {
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
  Map<String, CanvasText> evaluateNode(EvalInfo eval) {
    double x = eval.evaluateProperty('x');
    double y = eval.evaluateProperty('y');
    double width = eval.evaluateProperty('width');
    double height = eval.evaluateProperty('height');
    // String text = eval.evaluateProperty('text'); // TODO
    CanvasItemFill fill = eval.evaluateProperty('fill');
    double size = eval.evaluateProperty('size');
    double letterSpacing = eval.evaluateProperty('letter_spacing');

    return {
      'output': CanvasText(
        layerId: '',
        opacity: 100,
        blendMode: BlendMode.srcOver,
        x: x,
        y: y,
        width: width,
        height: height,
        text: 'Example text',
        fill: fill,
        border:
            CanvasItemBorder(fill: CanvasItemFill(fillType: FillType.solid, solidColor: Colors.black), thickness: 1.0),
        font: '',
        size: size,
        letterSpacing: letterSpacing,
        lineSpacing: 1.0,
      ),
    };
  }

  factory TextNode.clone(Node source, String id) {
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

class ImageNode extends Node {
  ImageNode({
    super.id = '',
    super.idname = 'image_corenode',
    super.isOutput = false,
    super.label = 'Image',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  Map<String, CanvasImage> evaluateNode(EvalInfo eval) {
    double x = eval.evaluateProperty('x');
    double y = eval.evaluateProperty('y');
    double width = eval.evaluateProperty('width');
    double height = eval.evaluateProperty('height');
    Photo photo = eval.evaluateProperty('photo');

    return {
      'output': CanvasImage(
        layerId: '',
        opacity: 100,
        blendMode: BlendMode.srcOver,
        x: x,
        y: y,
        width: width,
        height: height,
        imageData: photo.uiData,
      ),
    };
  }

  factory ImageNode.clone(Node source, String id) {
    return ImageNode(
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

class AddNode extends Node {
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

  factory AddNode.clone(Node source, String id) {
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

class OutputNode extends Node {
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
  (Node, String)? get connectedNode {
    Property prop = properties.values.firstWhere((item) => item.idname == 'layer');
    return prop.connection;
  }

  factory OutputNode.clone(Node source, String id) {
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

class OutputNode2 extends Node {
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
  (Node, String)? get connectedNode {
    Property prop = properties.values.firstWhere((item) => item.idname == 'layer');
    return prop.connection;
  }

  factory OutputNode2.clone(Node source, String id) {
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
