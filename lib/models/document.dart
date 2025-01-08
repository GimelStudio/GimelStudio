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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'size': [size.width, size.height],
      'layers': [for (Layer layer in layers) layer.toJson()],
    };
  }

  Document.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        size = Size(json['size'][0] as double, json['size'][1] as double),
        isSaved = true,
        layers = [for (Map<String, dynamic> layer in json['layers']) Layer.fromJson(layer)];

  @override
  String toString() {
    return 'Document{id: $id, name: $name, size: (${size.width}, ${size.height}), layers: $layers}';
  }
}
