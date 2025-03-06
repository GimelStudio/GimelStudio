import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/layer.dart';

class Document {
  Document({
    required this.id,
    required this.name,
    required this.size,
    this.isSaved = false,
    this.background = Colors.white,
    this.path = '',
    required this.layers,
    required this.selectedLayers,
    this.result = const [],
  });

  final String id;
  final String name;
  final Size size;
  String path;
  bool isSaved;
  Color background;
  List<Layer> layers;
  List<Layer> selectedLayers;
  List<CanvasItem> result; // Only used for the evaluation

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'size': [size.width, size.height],
      'layers': [for (Layer layer in layers) layer.toJson()],
    };
  }

  // TODO
  Document.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        size = Size(json['size'][0] as double, json['size'][1] as double),
        isSaved = true,
        background = Colors.white,
        path = '',
        layers = [for (Map<String, dynamic> layer in json['layers']) Layer.fromJson(layer)],
        selectedLayers = [],
        result = [];

  @override
  String toString() {
    return 'Document{id: $id, name: $name, size: (${size.width}, ${size.height}), layers: $layers}';
  }
}
