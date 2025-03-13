import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/services/nodegraphs_service.dart';

class CanvasItemService {
  final _evaluationService = locator<EvaluationService>();
  final _nodegraphsService = locator<NodegraphsService>();
  final _layersService = locator<LayersService>();

  List<Layer> get selectedLayers => _layersService.selectedLayers;

  void normalizeNegativeCanvasItemCoords(Node? itemNode, Offset lastPosition) {
    if (itemNode != null) {
      Property xProp = itemNode.getPropertyByIdname('x');
      Property yProp = itemNode.getPropertyByIdname('y');
      Property widthProp = itemNode.getPropertyByIdname('width');
      Property heightProp = itemNode.getPropertyByIdname('height');

      if (widthProp.value.isNegative || heightProp.value.isNegative) {
        Rect newRect = Rect.fromLTWH(
          lastPosition.dx,
          lastPosition.dy,
          widthProp.value.abs(),
          heightProp.value.abs(),
        );

        _nodegraphsService.onEditNodePropertyValue(xProp, newRect.topLeft.dx);
        _nodegraphsService.onEditNodePropertyValue(yProp, newRect.topLeft.dy);
        _nodegraphsService.onEditNodePropertyValue(widthProp, newRect.width);
        _nodegraphsService.onEditNodePropertyValue(heightProp, newRect.height);

        _evaluationService.evaluate(evaluateLayers: selectedLayers);
      }
    }
  }
}
