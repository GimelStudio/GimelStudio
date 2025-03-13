import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/models/tool.dart';
import 'package:gimelstudio/services/canvas_item_service.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/services/nodegraphs_service.dart';
import 'package:gimelstudio/services/overlays_service.dart';

class RectangleToolService implements ToolModeEventHandler {
  final _layersService = locator<LayersService>();
  final _evaluationService = locator<EvaluationService>();
  final _nodegraphsService = locator<NodegraphsService>();
  final _overlaysService = locator<OverlaysService>();
  final _documentService = locator<DocumentService>();
  final _canvasItemService = locator<CanvasItemService>();

  Node? itemNode;
  Offset? draggingStartPosition;
  Offset? lastPosition;

  List<Layer> get layers => _layersService.layers;
  List<Layer> get selectedLayers => _layersService.selectedLayers;

  List<CanvasItem> get items => _documentService.activeDocument?.result ?? [];

  @override
  void activate() {
    _overlaysService.setShowOverlays(false);
  }

  @override
  void deactivate() {
    _overlaysService.setShowOverlays(true);
  }

  @override
  void onHover(PointerHoverEvent event) {}

  @override
  void onTapDown(TapDownDetails event) {}

  @override
  void onPanDown(DragDownDetails event) {
    Layer layer = _layersService.addNewLayer(type: 'rectangle');
    _layersService.setLayerSelected(layer);
    itemNode = _layersService.canvasItemNodeFromLayer(layer);

    if (itemNode != null) {
      Property xProp = itemNode!.getPropertyByIdname('x');
      Property yProp = itemNode!.getPropertyByIdname('y');

      _nodegraphsService.onEditNodePropertyValue(xProp, event.localPosition.dx);
      _nodegraphsService.onEditNodePropertyValue(yProp, event.localPosition.dy);

      draggingStartPosition = event.localPosition;
      lastPosition = event.localPosition;

      _evaluationService.evaluate(evaluateLayers: selectedLayers);
    }
  }

  @override
  void onPanUpdate(DragUpdateDetails event) {
    if (selectedLayers.isEmpty || draggingStartPosition == null || lastPosition == null) {
      return;
    }

    if (itemNode != null) {
      Property xProp = itemNode!.getPropertyByIdname('x');
      Property yProp = itemNode!.getPropertyByIdname('y');
      Property widthProp = itemNode!.getPropertyByIdname('width');
      Property heightProp = itemNode!.getPropertyByIdname('height');

      Offset pos = Offset(
        event.localPosition.dx - lastPosition!.dx,
        event.localPosition.dy - lastPosition!.dy,
      );

      double newX = xProp.value;
      double newY = yProp.value;
      double newWidth = widthProp.value + (pos.dx);
      double newHeight = heightProp.value + (pos.dy);

      Rect newRect = Rect.fromLTWH(newX, newY, newWidth, newHeight);

      newX = newRect.topLeft.dx;
      newY = newRect.topLeft.dy;
      newWidth = newRect.width;
      newHeight = newRect.height;

      _nodegraphsService.onEditNodePropertyValue(xProp, newX);
      _nodegraphsService.onEditNodePropertyValue(yProp, newY);
      _nodegraphsService.onEditNodePropertyValue(widthProp, newWidth);
      _nodegraphsService.onEditNodePropertyValue(heightProp, newHeight);

      lastPosition = event.localPosition;

      _evaluationService.evaluate(evaluateLayers: selectedLayers);
    }
  }

  @override
  void onPanCancel() {
    _canvasItemService.normalizeNegativeCanvasItemCoords(itemNode, lastPosition!);

    itemNode = null;
    lastPosition = null;
    draggingStartPosition = null;
  }

  @override
  void onPanEnd(DragEndDetails event) {
    _canvasItemService.normalizeNegativeCanvasItemCoords(itemNode, lastPosition!);

    itemNode = null;
    lastPosition = null;
    draggingStartPosition = null;
  }
}
