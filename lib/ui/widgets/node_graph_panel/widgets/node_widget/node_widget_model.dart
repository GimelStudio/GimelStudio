import 'package:flutter/material.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:stacked/stacked.dart';

class NodeWidgetModel extends BaseViewModel {
  Offset? _draggingStartPosition;
  Offset? get draggingStartPosition => _draggingStartPosition;
  Offset? _draggingInitialNodePosition;
  Offset? get draggingInitialNodePosition => _draggingInitialNodePosition;

  double layoutSocketsVertically(List<dynamic> list, dynamic item) {
    // TODO
    return 8.0 + list.indexOf(item) * 20.0;
  }

  void onPanDown(DragDownDetails event, NodeBase node) {
    _draggingStartPosition = event.localPosition;
    _draggingInitialNodePosition = node.position;
    rebuildUi();
  }

  void onPanUpdate(DragUpdateDetails event, Function onNodeMoved) {
    onNodeMoved(draggingInitialNodePosition! + event.localPosition - draggingStartPosition!);
    rebuildUi();
  }

  void onPanCancel(Function onNodeMoved) {
    onNodeMoved(draggingInitialNodePosition!);

    _draggingStartPosition = null;
    _draggingInitialNodePosition = null;
    rebuildUi();
  }

  void onPanEnd(DragEndDetails event) {
    _draggingStartPosition = null;
    _draggingInitialNodePosition = null;

    rebuildUi();
  }
}
