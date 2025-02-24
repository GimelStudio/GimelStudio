import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Tool {
  cursor,
  hand,
  node,
  rectangle,
  circle,
  triangle,
  polygon,
  text,
  image,
  eyedropper,
}

class ToolModeEventHandler {
  /// Called when the user enters the tool mode
  void activate() {}

  /// Called when the user exits the tool mode.
  void deactivate() {}

  /// Triggered when a pointer moves into a position within this widget without buttons pressed.
  void onHover(PointerHoverEvent event) {}

  /// A pointer that might cause a tap with a primary button has contacted the screen at a particular location.
  void onTapDown(TapDownDetails event) {}

  /// A pointer has contacted the screen with a primary button and might begin to move.
  void onPanDown(DragDownDetails event) {}

  /// The mouse has clicked down and is dragging over the canvas.
  void onPanUpdate(DragUpdateDetails event) {}

  /// The pointer that previously triggered [onPanDown] did not complete.
  void onPanCancel() {}

  /// A pointer that was previously in contact with the screen with a primary button and
  /// moving is no longer in contact with the screen and was moving at a specific
  /// velocity when it stopped contacting the screen.
  void onPanEnd(DragEndDetails event) {}
}
