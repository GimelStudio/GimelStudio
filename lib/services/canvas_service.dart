import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CanvasService with ListenableServiceMixin {
  CanvasService() {
    listenToReactiveValues([
      _mouseCursor,
    ]);
  }

  MouseCursor _mouseCursor = SystemMouseCursors.basic;
  MouseCursor get mouseCursor => _mouseCursor;

  void setMouseCursor(MouseCursor cursor) {
    _mouseCursor = cursor;
    notifyListeners();
  }
}
