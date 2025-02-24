import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/tool.dart';
import 'package:gimelstudio/services/canvas_service.dart';
import 'package:gimelstudio/services/overlays_service.dart';

// TODO: implement panning
class HandToolService implements ToolModeEventHandler {
  final _overlaysService = locator<OverlaysService>();
  final _canvasService = locator<CanvasService>();

  @override
  void activate() {
    _overlaysService.setShowOverlays(false);
  }

  @override
  void deactivate() {
    _overlaysService.setShowOverlays(true);
  }

  @override
  void onHover(PointerHoverEvent event) {
    // TODO: the grab cursor is not available on Windows.
    _canvasService.setMouseCursor(SystemMouseCursors.grab);
  }

  @override
  void onTapDown(TapDownDetails event) {
    // TODO: the grabbing cursor is not available on Windows.
    _canvasService.setMouseCursor(SystemMouseCursors.grabbing);
  }

  @override
  void onPanDown(DragDownDetails event) {
    // TODO: the grabbing cursor is not available on Windows.
    _canvasService.setMouseCursor(SystemMouseCursors.grabbing);
  }

  @override
  void onPanUpdate(DragUpdateDetails event) {}

  @override
  void onPanCancel() {}

  @override
  void onPanEnd(DragEndDetails event) {}
}
