import 'package:flutter/material.dart';

enum NodeCategory {
  input,
  canvasItem,
  effect,
  output,
}

Map<NodeCategory, Color> nodeDatatypeColors = {
  NodeCategory.input: Color(0xFF7b242b),
  NodeCategory.canvasItem: Color(0xFF084D4D),
  NodeCategory.effect: Color(0xFF498DB8),
  NodeCategory.output: Color(0xFF084D4D),
};
