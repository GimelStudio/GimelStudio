import 'package:flutter/material.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:stacked/stacked.dart';

class NodeWidgetModel extends BaseViewModel {
  Offset? _draggingStartPosition;
  Offset? get draggingStartPosition => _draggingStartPosition;
  Offset? _draggingInitialNodePosition;
  Offset? get draggingInitialNodePosition => _draggingInitialNodePosition;

  double topHeight = 22.0;
  double bottomHeight = 8.0;

  double layoutSocketsVertically(List<dynamic> list, dynamic item) {
    // TODO
    return topHeight + (list.indexOf(item) * 18.0);
  }

  double getNodeHeight(List<dynamic> list) {
    return topHeight + (list.length * 18.0) + bottomHeight;
  }

  void onPanDown(DragDownDetails event, Node node) {
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
