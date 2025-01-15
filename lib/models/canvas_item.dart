// TODO
class CanvasItem {
  CanvasItem({
    required this.type,
    required this.opacity,
    //required this.blendMode,
    required this.x,
    required this.y,
  });

  final String type;
  int opacity;
  double x;
  double y;
}

// TODO
class Rectangle extends CanvasItem {
  Rectangle({
    super.type = 'rect',
    required super.opacity,
    required super.x,
    required super.y,
    required this.width,
    required this.height,
  });

  double width;
  double height;
}
