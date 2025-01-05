import 'package:flutter/material.dart';
import 'package:gimelstudio/models/layer.dart';

class Document {
  Document({
    required this.id,
    required this.name,
    required this.size,
    this.isSaved = false,
    required this.layers,
  });

  final String id;
  final String name;
  final Size size;
  bool isSaved;
  List<Layer> layers;

  @override
  String toString() {
    return 'id: $id, name: $name, size: (${size.width}X${size.height}), layers: $layers';
  }
}
