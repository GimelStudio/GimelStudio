import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

Rect calculateRectWithRotation(Rect rect, Offset origin, double rotation) {
  if (rotation == 0.0) {
    return rect;
  }
  return MatrixUtils.transformRect(
    Matrix4Transform().rotateDegrees(rotation, origin: origin).matrix4,
    rect,
  );
}
