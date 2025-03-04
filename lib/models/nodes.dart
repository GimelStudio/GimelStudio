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
    super.label = 'Rectangle',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  bool get isCanvasItemNode => true;

  @override
  Map<String, CanvasRectangle> evaluateNode(EvalInfo eval) {
    double x = eval.evaluateProperty('x');
    double y = eval.evaluateProperty('y');
    double width = eval.evaluateProperty('width');
    double height = eval.evaluateProperty('height');
    bool lockAspectRatio = eval.evaluateProperty('lock_aspect_ratio');
    double rotation = eval.evaluateProperty('rotation');
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
        lockAspectRatio: lockAspectRatio,
        rotation: rotation,
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
    super.label = 'Text',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  bool get isCanvasItemNode => true;

  @override
  Map<String, CanvasText> evaluateNode(EvalInfo eval) {
    double x = eval.evaluateProperty('x');
    double y = eval.evaluateProperty('y');
    double width = eval.evaluateProperty('width');
    double height = eval.evaluateProperty('height');
    String text = eval.evaluateProperty('text'); // TODO: this should not be shown in the properties panel
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
        text: text,
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
    super.label = 'Image',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  bool get isCanvasItemNode => true;

  @override
  Map<String, CanvasImage> evaluateNode(EvalInfo eval) {
    double x = eval.evaluateProperty('x');
    double y = eval.evaluateProperty('y');
    double width = eval.evaluateProperty('width');
    double height = eval.evaluateProperty('height');
    bool lockAspectRatio = eval.evaluateProperty('lock_aspect_ratio');
    double rotation = eval.evaluateProperty('rotation');
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
        lockAspectRatio: lockAspectRatio,
        rotation: rotation,
        imageData: photo.uiData,
      ),
    };
  }

  factory ImageNode.clone(Node source, String id) {
    return ImageNode(
      id: id,
      idname: source.idname,
      label: source.label,
      selected: source.selected,
      properties: source.properties,
      outputs: source.outputs,
      position: source.position,
    );
  }
}

class PhotoNode extends Node {
  PhotoNode({
    super.id = '',
    super.idname = 'photo_corenode',
    super.label = 'Photo',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  Map<String, Photo> evaluateNode(EvalInfo eval) {
    Photo photo = eval.evaluateProperty('photo');

    return {
      'output': photo,
    };
  }

  factory PhotoNode.clone(Node source, String id) {
    return PhotoNode(
      id: id,
      idname: source.idname,
      label: source.label,
      selected: source.selected,
      properties: source.properties,
      outputs: source.outputs,
      position: source.position,
    );
  }
}

class BlurNode extends Node {
  BlurNode({
    super.id = '',
    super.idname = 'blur_corenode',
    super.label = 'Blur',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  Map<String, Photo> evaluateNode(EvalInfo eval) {
    double radius = eval.evaluateProperty('radius');
    Photo photo = eval.evaluateProperty('photo');

    // TODO: Currently does nothing.
    return {
      'output': photo,
    };
  }

  factory BlurNode.clone(Node source, String id) {
    return BlurNode(
      id: id,
      idname: source.idname,
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
      label: source.label,
      selected: source.selected,
      properties: source.properties,
      outputs: source.outputs,
      position: source.position,
    );
  }
}

// TODO: maybe rename to LayerOutputNode
class OutputNode extends Node {
  OutputNode({
    super.id = '',
    super.idname = 'output_corenode',
    super.label = 'Output',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  bool get isLayerOutput => true;

  @override
  (Node, String)? get connectedNode {
    Property prop = properties.values.firstWhere((item) => item.idname == 'layer');
    return prop.connection;
  }

  @override
  Map<String, CanvasItem> evaluateNode(EvalInfo eval) {
    // TODO: add blend mode and opacity
    CanvasItem canvasItem = evaluateProperty(eval, 'layer');

    return {
      'output': canvasItem,
    };
  }

  factory OutputNode.clone(Node source, String id) {
    return OutputNode(
      id: id,
      idname: source.idname,
      label: source.label,
      selected: source.selected,
      properties: source.properties,
      outputs: source.outputs,
      position: source.position,
    );
  }
}
