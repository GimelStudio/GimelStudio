import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/ui/widgets/viewport_panel/viewport_panel.dart';
import 'package:stacked/stacked.dart';

class OverlaysService with ListenableServiceMixin {
  final _layersService = locator<LayersService>();

  OverlaysService() {
    listenToReactiveValues([
      _showOverlays,
      selectionOverlay,
    ]);
  }

  List<Layer> get selectedLayers => _layersService.selectedLayers;

  bool _showOverlays = true;
  bool get showOverlays => _showOverlays;

  SelectionBoxOverlay? get selectionOverlay =>
      _showOverlays == true ? calculateSelectionBoxOverlay(selectedLayers, viewportScale) : null;

  double _viewportScale = 1.0;
  double get viewportScale => _viewportScale;

  String textInputOverlayText = '';
  TextInputOverlay? get textInputOverlay => TextInputOverlay(text: textInputOverlayText);

  void setViewportScale(double scale) {
    _viewportScale = scale;
    notifyListeners();
  }

  void changeText(String text) {
    textInputOverlayText = text;
    notifyListeners();
  }

  bool isWithinSelectionBounds(Offset position) {
    return selectionOverlay?.itemBounds.contains(position) ?? false;
  }

  SelectionBoxOverlay? calculateSelectionBoxOverlay(List<Layer> selectedLayers, double viewportScale) {
    if (selectedLayers.isEmpty) {
      return null;
    } else {
      return SelectionBoxOverlay(scale: viewportScale, itemBounds: calculateMinBounds(selectedLayers));
    }
  }

  Rect calculateMinBounds(List<Layer> selectedLayers) {
    List<Offset> points = [];
    for (Layer item in selectedLayers) {
      Rect rectBounds = item.value.bounds;

      points.add(rectBounds.topLeft);
      points.add(rectBounds.bottomRight);
    }

    if (points.isEmpty) return Rect.zero;

    double minX = points.first.dx;
    double maxX = points.first.dx;
    double minY = points.first.dy;
    double maxY = points.first.dy;

    for (Offset point in points) {
      minX = min(minX, point.dx);
      maxX = max(maxX, point.dx);
      minY = min(minY, point.dy);
      maxY = max(maxY, point.dy);
    }

    return Rect.fromLTWH(minX, minY, maxX - minX, maxY - minY);
  }

  void setShowOverlays(bool showOverlays) {
    _showOverlays = showOverlays;
    notifyListeners();
  }
}
