import 'package:gimelstudio/models/nodegraph.dart';

enum BlendMode {
  normal,
  darken,
  multiply,
  colorBurn,
  // ...
}

class Layer {
  Layer({
    required this.id,
    required this.index,
    required this.name,
    required this.selected,
    required this.visible,
    required this.locked,
    required this.opacity,
    required this.blend,
    required this.nodegraph,
  });

  final int id;
  int index;
  String name;
  bool selected;
  bool visible;
  bool locked;
  int opacity;
  BlendMode blend;
  NodeGraph nodegraph;

  dynamic thumbnail = null;

  void setIndex(int newIndex) {
    index = newIndex;
  }

  void setSelected(bool isSelected) {
    selected = isSelected;
  }

  void setVisibility(bool isVisible) {
    visible = isVisible;
  }

  void setLocked(bool isLocked) {
    locked = isLocked;
  }

  @override
  String toString() {
    return '$index';
  }
}
