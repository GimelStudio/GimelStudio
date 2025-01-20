// TODO
import 'package:flutter/material.dart';

enum FillType {
  solid,
  linearGradient,
  radialGradient,
}

class CanvasItemFill {
  // TODO: maybe make this more general for use outside of canvas items?
  CanvasItemFill({
    required this.fillType,
    required this.solidColor,
    // required this.gradientColors...
  });

  FillType fillType;
  Color solidColor;
}

class CanvasItemBorder {
  CanvasItemBorder({
    required this.thickness,
  });

  double thickness;
}

abstract class CanvasItem {
  CanvasItem({
    required this.type,
    required this.opacity,
    required this.blendMode,
  });

  final String type;
  int opacity;
  BlendMode blendMode;
}

// TODO
class Rectangle extends CanvasItem {
  Rectangle({
    super.type = 'rect',
    required super.opacity,
    required super.blendMode,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.fill,
  });

  double x;
  double y;
  double width;
  double height;
  CanvasItemFill fill;
}

class Text extends CanvasItem {
  Text({
    super.type = 'text',
    required super.opacity,
    required super.blendMode,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.text,
    required this.fill,
    required this.border,
    required this.font,
    required this.size,
    required this.letterSpacing,
    required this.lineSpacing,
  });

  double x;
  double y;
  double width;
  double height;
  String text;
  CanvasItemFill fill;
  CanvasItemBorder border;
  String font;
  double size;
  double letterSpacing;
  double lineSpacing;
}
