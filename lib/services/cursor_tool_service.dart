import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/models/tool.dart';
import 'package:gimelstudio/services/canvas_service.dart';
import 'package:gimelstudio/services/document_service.dart';
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
  final _documentService = locator<DocumentService>();

  List<Layer> get layers => _layersService.layers;
  List<Layer> get selectedLayers => _layersService.selectedLayers;

  SelectionBoxOverlay? get selectionOverlay => _overlaysService.selectionOverlay;

  List<CanvasItem> get items => _documentService.activeDocument?.result ?? [];

  Map<String, Rect> lastRects = {};
  Offset? lastPosition;
  Map<String, Offset> draggingStartPositions = {};
  SelectionOverlayHandleSide? currentSelectionHandleSide;

  @override
  void activate() {}

  @override
  void deactivate() {}

  @override
  void onHover(PointerHoverEvent event) {
    Offset hoverPosition = event.localPosition;

    if (selectedLayers.isNotEmpty && selectionOverlay != null) {
      SelectionOverlayHandleSide? handle = selectionOverlay!.getHandle(hoverPosition);
      // Set the current overlay handle.
      currentSelectionHandleSide = handle;

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
    } else {
      _canvasService.setMouseCursor(SystemMouseCursors.basic);
    }
  }

  @override
  void onTapDown(TapDownDetails event) {
    Layer? layer = _layersService.getLayerFromPosition(event.localPosition, items, layers);

    if (layer == null) {
      if (selectedLayers.length <= 1 && currentSelectionHandleSide == null) {
        // User clicked in an empty area of the canvas.
        _layersService.deselectAllLayers();
      } else {
        // If the mouse down is not within the selection bounds, then deselect all.
        if (_overlaysService.isWithinSelectionBounds(event.localPosition) == false) {
          if (currentSelectionHandleSide == null) {
            _layersService.deselectAllLayers();
          }
        }
      }
      return;
    } else {
      // Don't allow a locked layer to be selected.
      if (layer.locked == true) {
        return;
      }
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
        if (currentSelectionHandleSide == null) {
          _layersService.setLayerSelected(layer);
        }
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
          if (currentSelectionHandleSide == null) {
            _layersService.deselectAllLayers();
          }
          return;
        }

        Property xProp = itemNode.getPropertyByIdname('x');
        Property yProp = itemNode.getPropertyByIdname('y');
        Property widthProp = itemNode.getPropertyByIdname('width');
        Property heightProp = itemNode.getPropertyByIdname('height');

        lastRects[layer.id] = Rect.fromLTWH(xProp.value, yProp.value, widthProp.value, heightProp.value);
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
        if (currentSelectionHandleSide == null) {
          _layersService.deselectAllLayers();
        }
      } else {
        // Don't allow a locked layer to be selected.
        if (currentSelectionHandleSide == null && layer.locked == false) {
          _layersService.setLayerSelected(layer);
        }
      }
    }

    for (Layer layer in selectedLayers) {
      if (layer.locked == false) {
        Node? itemNode = _layersService.canvasItemNodeFromLayer(layer);

        // Deselect all if mouse down was outside of the bounds of a canvas item.
        if (itemNode == null) {
          if (currentSelectionHandleSide == null) {
            _layersService.deselectAllLayers();
          }
          return;
        }

        Property xProp = itemNode.getPropertyByIdname('x');
        Property yProp = itemNode.getPropertyByIdname('y');
        Property widthProp = itemNode.getPropertyByIdname('width');
        Property heightProp = itemNode.getPropertyByIdname('height');

        lastRects[layer.id] = Rect.fromLTWH(xProp.value, yProp.value, widthProp.value, heightProp.value);
        draggingStartPositions[layer.id] = Offset(xProp.value, yProp.value);
      }
    }

    lastPosition = event.localPosition;
  }

  @override
  void onPanUpdate(DragUpdateDetails event) {
    if (selectedLayers.isEmpty || draggingStartPositions.isEmpty || lastPosition == null) {
      if (currentSelectionHandleSide == null) {
        _layersService.deselectAllLayers();
      }
      return;
    }

    for (Layer layer in selectedLayers) {
      if (layer.locked == false) {
        Node? itemNode = _layersService.canvasItemNodeFromLayer(layer);

        if (itemNode != null) {
          Property xProp = itemNode.getPropertyByIdname('x');
          Property yProp = itemNode.getPropertyByIdname('y');
          Property widthProp = itemNode.getPropertyByIdname('width');
          Property heightProp = itemNode.getPropertyByIdname('height');

          Offset pos = Offset(
            event.localPosition.dx - lastPosition!.dx,
            event.localPosition.dy - lastPosition!.dy,
          );

          Rect lastRect = lastRects[layer.id]!;
          Rect newRect = Rect.fromLTRB(
            lastRect.left,
            lastRect.top,
            lastRect.right,
            lastRect.bottom,
          );

          switch (currentSelectionHandleSide) {
            case SelectionOverlayHandleSide.top:
              newRect = Rect.fromLTRB(
                lastRect.left,
                lastRect.top + pos.dy,
                lastRect.right,
                lastRect.bottom,
              );
            case SelectionOverlayHandleSide.topRight:
              newRect = Rect.fromLTRB(
                lastRect.left,
                lastRect.top + pos.dy,
                lastRect.right + pos.dx,
                lastRect.bottom,
              );
            case SelectionOverlayHandleSide.right:
              newRect = Rect.fromLTWH(
                lastRect.left,
                lastRect.top,
                lastRect.width + pos.dx,
                lastRect.height,
              );
            case SelectionOverlayHandleSide.bottomRight:
              newRect = Rect.fromLTWH(
                lastRect.left,
                lastRect.top,
                lastRect.width + pos.dx,
                lastRect.height + pos.dy,
              );
            case SelectionOverlayHandleSide.bottom:
              newRect = Rect.fromLTRB(
                lastRect.left,
                lastRect.top,
                lastRect.right,
                lastRect.bottom + pos.dy,
              );
            case SelectionOverlayHandleSide.bottomLeft:
              newRect = Rect.fromLTRB(
                lastRect.left + pos.dx,
                lastRect.top,
                lastRect.right,
                lastRect.bottom + pos.dy,
              );
            case SelectionOverlayHandleSide.left:
              newRect = Rect.fromLTWH(
                lastRect.left + pos.dx,
                lastRect.top,
                lastRect.width - pos.dx,
                lastRect.height,
              );
            case SelectionOverlayHandleSide.topLeft:
              newRect = Rect.fromLTRB(
                lastRect.left + pos.dx,
                lastRect.top + pos.dy,
                lastRect.right,
                lastRect.bottom,
              );
            default:
              Offset startPosition = draggingStartPositions[layer.id]!;

              newRect = Rect.fromLTWH(
                startPosition.dx + (pos.dx),
                startPosition.dy + (pos.dy),
                lastRect.width,
                lastRect.height,
              );
          }

          // TODO: proportionally scale if there is more than one selection
          if (selectedLayers.length > 1) {
            newRect = Rect.fromLTWH(
              newRect.left,
              newRect.top,
              newRect.width,
              newRect.height,
            );
          }

          _nodegraphsService.onEditNodePropertyValue(xProp, newRect.topLeft.dx);
          _nodegraphsService.onEditNodePropertyValue(yProp, newRect.topLeft.dy);
          _nodegraphsService.onEditNodePropertyValue(widthProp, newRect.width);
          _nodegraphsService.onEditNodePropertyValue(heightProp, newRect.height);
        }
      }
    }

    _evaluationService.evaluate(evaluateLayers: selectedLayers);
  }

  @override
  void onPanCancel() {
    lastRects = {};
    lastPosition = null;
    draggingStartPositions = {};
    currentSelectionHandleSide = null;
  }

  @override
  void onPanEnd(DragEndDetails event) {
    lastRects = {};
    lastPosition = null;
    draggingStartPositions = {};
    currentSelectionHandleSide = null;
  }
}
