import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/photo.dart';

Map<dynamic, Color> nodeDatatypeColors = {
  int: Colors.blueGrey,
  double: Colors.grey,
  Photo: Colors.pink,
  CanvasItem: const Color(0xFFCBCE17),
  CanvasItemFill: Colors.lightBlue,
  CanvasItemBorder: Colors.purple,
};
