import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/models/tool.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:gimelstudio/services/image_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/services/export_service.dart';
import 'package:gimelstudio/services/nodegraphs_service.dart';
import 'package:gimelstudio/services/viewport_service.dart';
import 'package:gimelstudio/ui/widgets/viewport_panel/viewport_panel.dart';

import '../../../app/app.locator.dart';
import 'package:stacked/stacked.dart';

class ViewportPanelModel extends ReactiveViewModel {
  final _imageService = locator<ImageService>();
  final _evaluationService = locator<EvaluationService>();
  final _layersService = locator<LayersService>();
  final _exportService = locator<ExportService>();
  final _nodegraphsService = locator<NodegraphsService>();
  final _viewportService = locator<ViewportService>();
  final _documentService = locator<DocumentService>();

  Tool get activeTool => _viewportService.activeTool;

  MouseCursor _mouseCursor = SystemMouseCursors.basic;
  MouseCursor get mouseCursor => _mouseCursor;

  List<CanvasItem>? get result => _evaluationService.result;

  List<CanvasItem> get items => result == null ? [] : result ?? [];

  CanvasItem? get selectedItem => items.isEmpty ? null : items.reversed.toList()[_layersService.selectedLayerIndex];

  List<Layer> get layers => _layersService.layers;

  Document? get selectedDocument => _documentService.selectedDocument;

  Layer? get selectedLayer => _layersService.selectedLayer;


  Node? itemNode;

  SelectionBoxOverlay? get selectionOverlay =>
      items.isEmpty ? null : SelectionBoxOverlay(itemBounds: selectedItem!.bounds);

  Offset? _draggingStartPosition;
  Offset? get draggingStartPosition => _draggingStartPosition;
  Offset? _draggingInitialPosition;
  Offset? get draggingInitialPosition => _draggingInitialPosition;

  Offset? _lastPosition;
  Offset? get lastPosition => _lastPosition;

  // TODO: this logic is WIP. Think of this like a "first draft".
  // It should be refactored and moved into the viewport service, etc.

  // TODO: selecting a layer in the layers panel doesn't update the viewport selection.

  // How should grouping work?

  void setPropertyValue(Property property, dynamic value) {
    _nodegraphsService.onEditNodePropertyValue(property, value);
  }

  void setItemNode(Offset position) {
    Layer? layer;
    if (activeTool == Tool.cursor) {
      CanvasItem? item =
          items.cast<CanvasItem?>().lastWhere((CanvasItem? item) => item!.isInside(position), orElse: () => null);

      if (item != null) {
        List<Layer> documentLayers = List.from(layers.where((item) => item.visible == true));
        documentLayers.sort((Layer a, Layer b) => a.index.compareTo(b.index));
        layer = documentLayers.firstWhere((layer) => layer.id == item.layerId);

        // TODO: this assumes there is only one CanvasItem node in the nodegraph
        itemNode = layer.nodegraph.nodes.values.firstWhere((node) => node.idname == '${item.type}_corenode');
        _layersService.setSelectedLayer(layer);
      } else {
        itemNode = null;
      }
    }
  }

  void selectCanvasItem(Layer layer) {}

  void onHover(PointerHoverEvent event) {
    Offset hoverPosition = event.localPosition;

    if (selectedItem != null && selectionOverlay != null) {
      SelectionOverlayHandleSide? handle = selectionOverlay!.getHandle(hoverPosition);

      switch (handle) {
        case SelectionOverlayHandleSide.top:
          _mouseCursor = SystemMouseCursors.resizeUp;
        case SelectionOverlayHandleSide.topLeft:
          _mouseCursor = SystemMouseCursors.resizeUpLeft;
        case SelectionOverlayHandleSide.left:
          _mouseCursor = SystemMouseCursors.resizeLeft;
        case SelectionOverlayHandleSide.bottomLeft:
          _mouseCursor = SystemMouseCursors.resizeDownLeft;
        case SelectionOverlayHandleSide.bottom:
          _mouseCursor = SystemMouseCursors.resizeDown;
        case SelectionOverlayHandleSide.topRight:
          _mouseCursor = SystemMouseCursors.resizeDownLeft;
        case SelectionOverlayHandleSide.right:
          _mouseCursor = SystemMouseCursors.resizeRight;
        case SelectionOverlayHandleSide.bottomRight:
          _mouseCursor = SystemMouseCursors.resizeUpLeft;
        default:
          _mouseCursor = SystemMouseCursors.basic;
      }
    }
    rebuildUi();
  }

  void onTapDown(TapDownDetails event) {
    print('onTapDown');
    setItemNode(event.localPosition);
    rebuildUi();
  }

  void onPanDown(DragDownDetails event) {
    if (activeTool == Tool.cursor) {
      setItemNode(event.localPosition);

      if (itemNode != null) {
        _draggingStartPosition = event.localPosition;

        Property xProp = itemNode!.getPropertyByIdname('x');
        Property yProp = itemNode!.getPropertyByIdname('y');

        _draggingInitialPosition = Offset(xProp.value, yProp.value);
      }
    }

    if (activeTool == Tool.rectangle) {
      Layer layer = _layersService.addNewLayer(type: 'rectangle');

      // TODO: this assumes there is only one CanvasItem node in the nodegraph
      itemNode = layer.nodegraph.nodes.values.firstWhere((node) => node.idname == 'rectangle_corenode');
      _layersService.setSelectedLayer(layer);

      _draggingStartPosition = event.localPosition;

      Property xProp = itemNode!.getPropertyByIdname('x');
      Property yProp = itemNode!.getPropertyByIdname('y');

      setPropertyValue(xProp, event.localPosition!.dx);
      setPropertyValue(yProp, event.localPosition!.dy);

      _draggingInitialPosition = Offset(xProp.value, yProp.value);
      _lastPosition = event.localPosition;

      _evaluationService.evaluate(evaluateLayer: selectedLayer);
    }

    _mouseCursor = SystemMouseCursors.basic;

    rebuildUi();
  }

  void onPanUpdate(DragUpdateDetails event) {
    if (itemNode != null && _draggingStartPosition != null && _draggingInitialPosition != null) {
      Offset pos = draggingInitialPosition! + event.localPosition - draggingStartPosition!;

      Property xProp = itemNode!.getPropertyByIdname('x');
      Property yProp = itemNode!.getPropertyByIdname('y');

      if (activeTool == Tool.cursor) {
        setPropertyValue(xProp, pos.dx);
        setPropertyValue(yProp, pos.dy);
      }

      if (activeTool == Tool.rectangle && _lastPosition != null) {
        Property widthProp = itemNode!.getPropertyByIdname('width');
        Property heightProp = itemNode!.getPropertyByIdname('height');

        var pos = Offset(event.localPosition.dx - _lastPosition!.dx, event.localPosition.dy - _lastPosition!.dy);

        setPropertyValue(widthProp, widthProp.value + (pos.dx));
        setPropertyValue(heightProp, heightProp.value + (pos.dy));

        _lastPosition = event.localPosition;
      }

      _evaluationService.evaluate(evaluateLayer: selectedLayer);
    }
    rebuildUi();
  }

  void onPanCancel() {
    _lastPosition = null;
    _draggingStartPosition = null;
    _draggingInitialPosition = null;
    rebuildUi();
  }

  void onPanEnd(DragEndDetails event) {
    _lastPosition = null;
    _draggingStartPosition = null;
    _draggingInitialPosition = null;

    if (activeTool == Tool.rectangle) {
      _viewportService.setActiveTool(Tool.cursor);
    }

    rebuildUi();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_imageService, _evaluationService];
}
