import 'dart:math' as math;
import 'dart:ui' as ui;
// TODO
import 'package:flutter/material.dart';

enum FillType {
  none,
  solid,
  linearGradient,
  radialGradient,
}

class CanvasItemBorderRadius {
  CanvasItemBorderRadius({
    required this.cornerRadi,
    this.smoothCorners = false,
  });

  // TODO: revisit cornerRadi, because it assumes four corners.
  // In most applications, for (non-rectangle) polygons
  // with more or less than 4 sides, the option to set individual corners
  // is not displayed. We could just use the first three for a triangle and
  // for other (non-rectangle) polygons, use the first value for the radius.
  (double, double, double, double) cornerRadi;

  /// TODO: for ideas on implementation see:
  /// https://www.figma.com/blog/desperately-seeking-squircles/
  ///
  /// This is useful for making squircles.
  bool smoothCorners;
}

class CanvasItemFill {
  // TODO: maybe make this more general for use outside of canvas items?
  CanvasItemFill({
    required this.fillType,
    required this.solidColor,
    this.gradientColors = const [Colors.black, Colors.white],
    this.gradientStops = const [0.0, 1.0],
  });

  FillType fillType;
  Color solidColor;
  List<Color> gradientColors;
  List<double> gradientStops;
}

class CanvasItemBorder {
  CanvasItemBorder({
    required this.fill,
    required this.thickness,
  });

  CanvasItemFill fill;
  double thickness;
}

abstract class CanvasItem {
  CanvasItem({
    required this.type,
    required this.layerId,
    required this.opacity,
    required this.blendMode,
  });

  /// A string representing the type of canvas item.
  final String type;

  /// The id of the layer that "owns" this CanvasItem.
  String layerId;

  /// Opacity of the canvas item.
  int opacity;

  /// Blend mode of the canvas item.
  BlendMode blendMode;

  /// The center origin of the CanvasItem for rotation.
  Offset origin = const Offset(0, 0);

  /// A [Rect] describing the current outer bounds of the canvas item.
  ///
  /// This is used for the selection box.
  Rect bounds = const Rect.fromLTWH(0, 0, 0, 0);

  /// Whether [point] is inside the CanvasItem.
  ///
  /// This is used for selection hittests.
  bool isInside(Offset point) {
    return false;
  }
}

// TODO
class CanvasRectangle extends CanvasItem {
  CanvasRectangle({
    super.type = 'rectangle',
    required super.layerId,
    required super.opacity,
    required super.blendMode,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.fill,
    required this.border,
    required this.borderRadius,
  });

  double x;
  double y;
  double width;
  double height;
  CanvasItemFill fill;
  CanvasItemBorder border;
  CanvasItemBorderRadius borderRadius;

  @override
  Rect get bounds => Rect.fromLTWH(x, y, width, height);

  @override
  bool isInside(Offset point) {
    // TODO: for a rectangle with no fill, calculated edges
    RRect rect = RRect.fromRectAndCorners(
      Rect.fromLTWH(x, y, width, height),
      topLeft: Radius.circular(borderRadius.cornerRadi.$1),
      topRight: Radius.circular(borderRadius.cornerRadi.$2),
      bottomRight: Radius.circular(borderRadius.cornerRadi.$3),
      bottomLeft: Radius.circular(borderRadius.cornerRadi.$4),
    );

    return rect.contains(point);
  }
}

class CanvasOval extends CanvasItem {
  CanvasOval({
    super.type = 'oval',
    required super.layerId,
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

  @override
  Rect get bounds => Rect.fromLTWH(x, y, width, height);

  @override
  bool isInside(Offset point) {
    Rect rect = Rect.fromLTWH(x, y, width, height);

    double a = rect.right - rect.center.dx;
    double b = rect.center.dy - rect.top;

    return math.pow(point.dx - rect.center.dx, 2) / math.pow(a, 2) +
            math.pow(point.dy - rect.center.dy, 2) / math.pow(b, 2) <=
        1;
  }
}

class CanvasText extends CanvasItem {
  CanvasText({
    super.type = 'text',
    required super.layerId,
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

  @override
  Rect get bounds => Rect.fromLTWH(x, y, width, height);

  @override
  bool isInside(Offset point) {
    Rect rect = Rect.fromLTWH(x, y, width, height);
    return rect.contains(point);
  }
}

// TODO: maybe image should be a Rectangle with an Image fill?
class CanvasImage extends CanvasItem {
  CanvasImage({
    super.type = 'image',
    required super.layerId,
    required super.opacity,
    required super.blendMode,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.imageData,
  });

  double x;
  double y;
  double width;
  double height;
  ui.Image? imageData;

  @override
  Rect get bounds => Rect.fromLTWH(x, y, width, height);

  @override
  bool isInside(Offset point) {
    Rect rect = Rect.fromLTWH(x, y, width, height);
    return rect.contains(point);
  }
}
