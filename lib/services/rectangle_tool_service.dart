import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/models/tool.dart';
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

    Node? itemNode = _layersService.canvasItemNodeFromLayer(layer);

    if (itemNode == null) {
      return;
    }

    _layersService.setLayerSelected(layer);

    draggingStartPosition = event.localPosition;

    Property xProp = itemNode.getPropertyByIdname('x');
    Property yProp = itemNode.getPropertyByIdname('y');

    _nodegraphsService.onEditNodePropertyValue(xProp, event.localPosition.dx);
    _nodegraphsService.onEditNodePropertyValue(yProp, event.localPosition.dy);

    lastPosition = event.localPosition;

    _evaluationService.evaluate(evaluateLayers: selectedLayers);
  }

  @override
  void onPanUpdate(DragUpdateDetails event) {
    if (selectedLayers.isEmpty || draggingStartPosition == null || lastPosition == null) {
      return;
    }

    for (Layer layer in selectedLayers) {
      Node? itemNode = _layersService.canvasItemNodeFromLayer(layer);

      if (itemNode != null) {
        Property widthProp = itemNode.getPropertyByIdname('width');
        Property heightProp = itemNode.getPropertyByIdname('height');

        Offset pos = Offset(
          event.localPosition.dx - lastPosition!.dx,
          event.localPosition.dy - lastPosition!.dy,
        );

        _nodegraphsService.onEditNodePropertyValue(widthProp, widthProp.value + (pos.dx));
        _nodegraphsService.onEditNodePropertyValue(heightProp, heightProp.value + (pos.dy));

        lastPosition = event.localPosition;
      }
    }

    _evaluationService.evaluate(evaluateLayers: selectedLayers);
  }

  @override
  void onPanCancel() {
    lastPosition = null;
    draggingStartPosition = null;
  }

  @override
  void onPanEnd(DragEndDetails event) {
    lastPosition = null;
    draggingStartPosition = null;
  }
}
