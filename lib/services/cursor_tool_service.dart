import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/models/tool.dart';
import 'package:gimelstudio/services/canvas_service.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/services/nodegraphs_service.dart';
import 'package:gimelstudio/services/overlays_service.dart';
import 'package:gimelstudio/ui/widgets/viewport_panel/viewport_panel.dart';

class CursorToolService implements ToolModeEventHandler {
  final _layersService = locator<LayersService>();
  final _evaluationService = locator<EvaluationService>();
  final _nodegraphsService = locator<NodegraphsService>();
  final _overlaysService = locator<OverlaysService>();
  final _canvasService = locator<CanvasService>();

  List<Layer> get layers => _layersService.layers;
  List<Layer> get selectedLayers => _layersService.selectedLayers;

  SelectionBoxOverlay? get selectionOverlay => _overlaysService.selectionOverlay;

  List<CanvasItem> get items => _evaluationService.result;

  Map<String, Offset> draggingStartPositions = {};
  Offset? lastPosition;

  @override
  void activate() {}

  @override
  void deactivate() {}

  @override
  void onHover(PointerHoverEvent event) {
    Offset hoverPosition = event.localPosition;

    if (selectedLayers.isNotEmpty && selectionOverlay != null) {
      SelectionOverlayHandleSide? handle = selectionOverlay!.getHandle(hoverPosition);

      switch (handle) {
        case SelectionOverlayHandleSide.top:
          _canvasService.setMouseCursor(SystemMouseCursors.resizeUp);
        case SelectionOverlayHandleSide.topLeft:
          _canvasService.setMouseCursor(SystemMouseCursors.resizeUpLeft);
        case SelectionOverlayHandleSide.left:
          _canvasService.setMouseCursor(SystemMouseCursors.resizeLeft);
        case SelectionOverlayHandleSide.bottomLeft:
          _canvasService.setMouseCursor(SystemMouseCursors.resizeDownLeft);
        case SelectionOverlayHandleSide.bottom:
          _canvasService.setMouseCursor(SystemMouseCursors.resizeDown);
        case SelectionOverlayHandleSide.topRight:
          _canvasService.setMouseCursor(SystemMouseCursors.resizeDownLeft);
        case SelectionOverlayHandleSide.right:
          _canvasService.setMouseCursor(SystemMouseCursors.resizeRight);
        case SelectionOverlayHandleSide.bottomRight:
          _canvasService.setMouseCursor(SystemMouseCursors.resizeUpLeft);
        default:
          _canvasService.setMouseCursor(SystemMouseCursors.basic);
      }
    }
  }

  @override
  void onTapDown(TapDownDetails event) {
    Layer? layer = _layersService.getLayerFromPosition(event.localPosition, items, layers);

    if (layer == null) {
      if (selectedLayers.length <= 1) {
        // User clicked in an empty area of the canvas.
        _layersService.deselectAllLayers();
      } else {
        // If the mouse down is not within the selection bounds, then deselect all.
        if (_overlaysService.isWithinSelectionBounds(event.localPosition) == false) {
          _layersService.deselectAllLayers();
        }
      }
      return;
    }

    // Multi-selection mode (LMB+Shift).
    if (HardwareKeyboard.instance.isShiftPressed == true) {
      if (selectedLayers.contains(layer) == false && layer.locked == false) {
        // Add to the selection.
        _layersService.addLayerToSelected(layer);
      } else {
        // If the layer is already in the selection, remove it.
        _layersService.removeFromSelected(layer);
      }
      // Normal selection mode (LMB).
    } else {
      // Single item selection.
      if (selectedLayers.length <= 1) {
        _layersService.setLayerSelected(layer);
      } else {
        // Multiple items are selected, but we are no longer in
        // multi-select mode so we change the selection to the
        // clicked item outside of the current multi-selection.
        if (selectedLayers.contains(layer) == false) {
          _layersService.deselectAllLayers();
          _layersService.setLayerSelected(layer);
        }
      }
    }

    for (Layer layer in selectedLayers) {
      if (layer.locked == false) {
        Node? itemNode = _layersService.canvasItemNodeFromLayer(layer);

        // Deselect all if mouse down was outside of the bounds of a canvas item.
        if (itemNode == null) {
          _layersService.deselectAllLayers();
          return;
        }

        Property xProp = itemNode.getPropertyByIdname('x');
        Property yProp = itemNode.getPropertyByIdname('y');

        draggingStartPositions[layer.id] = Offset(xProp.value, yProp.value);
      }
    }

    lastPosition = event.localPosition;
  }

  @override
  void onPanDown(DragDownDetails event) {
    // Handle drag-LMB selection.
    if (selectedLayers.length <= 1 && HardwareKeyboard.instance.isShiftPressed == false) {
      Layer? layer = _layersService.getLayerFromPosition(event.localPosition, items, layers);
      if (layer == null) {
        _layersService.deselectAllLayers();
      } else {
        _layersService.setLayerSelected(layer);
      }
    }

    for (Layer layer in selectedLayers) {
      if (layer.locked == false) {
        Node? itemNode = _layersService.canvasItemNodeFromLayer(layer);

        // Deselect all if mouse down was outside of the bounds of a canvas item.
        if (itemNode == null) {
          _layersService.deselectAllLayers();
          return;
        }

        Property xProp = itemNode.getPropertyByIdname('x');
        Property yProp = itemNode.getPropertyByIdname('y');

        draggingStartPositions[layer.id] = Offset(xProp.value, yProp.value);
      }
    }

    lastPosition = event.localPosition;
  }

  @override
  void onPanUpdate(DragUpdateDetails event) {
    if (selectedLayers.isEmpty || draggingStartPositions.isEmpty || lastPosition == null) {
      _layersService.deselectAllLayers();
      return;
    }

    for (Layer layer in selectedLayers) {
      if (layer.locked == false) {
        Node? itemNode = _layersService.canvasItemNodeFromLayer(layer);

        if (itemNode != null) {
          Property xProp = itemNode.getPropertyByIdname('x');
          Property yProp = itemNode.getPropertyByIdname('y');

          Offset pos = Offset(
            event.localPosition.dx - lastPosition!.dx,
            event.localPosition.dy - lastPosition!.dy,
          );

          _nodegraphsService.onEditNodePropertyValue(xProp, draggingStartPositions[layer.id]!.dx + (pos.dx));
          _nodegraphsService.onEditNodePropertyValue(yProp, draggingStartPositions[layer.id]!.dy + (pos.dy));
        }
      }
    }

    _evaluationService.evaluate(evaluateLayers: selectedLayers);
  }

  @override
  void onPanCancel() {
    lastPosition = null;
    draggingStartPositions = {};
  }

  @override
  void onPanEnd(DragEndDetails event) {
    lastPosition = null;
    draggingStartPositions = {};
  }
}
