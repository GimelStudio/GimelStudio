import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/models/tool.dart';
import 'package:gimelstudio/services/canvas_service.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:gimelstudio/services/image_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/services/overlays_service.dart';
import 'package:gimelstudio/services/viewport_service.dart';
import 'package:gimelstudio/ui/widgets/viewport_panel/viewport_panel.dart';
import 'package:stacked/stacked.dart';

class ViewportPanelModel extends ReactiveViewModel {
  final _imageService = locator<ImageService>();
  final _evaluationService = locator<EvaluationService>();
  final _layersService = locator<LayersService>();
  final _viewportService = locator<ViewportService>();
  final _documentService = locator<DocumentService>();
  final _overlaysService = locator<OverlaysService>();
  final _canvasService = locator<CanvasService>();

  Tool get activeTool => _viewportService.activeTool;
  dynamic get toolModeHandler => _viewportService.toolModeHandler;

  MouseCursor get mouseCursor => _canvasService.mouseCursor;

  Document? get activeDocument => _documentService.activeDocument;

  List<Layer> get layers => _layersService.layers;
  List<Layer> get selectedLayers => _layersService.selectedLayers;

  List<CanvasItem> get items => activeDocument?.result ?? [];

  SelectionBoxOverlay? get selectionOverlay => _overlaysService.selectionOverlay;
  TextInputOverlay? get textInputOverlay => _overlaysService.textInputOverlay;

  TransformationController transformationController = TransformationController();

  void onDispose() {
    transformationController.dispose();
  }

  void setViewportScale(double scale) {
    _overlaysService.setViewportScale(scale);
  }

  void onChangeText(String text) {
    _overlaysService.changeText(text);
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [
        _imageService,
        _evaluationService,
        _documentService,
        _layersService,
        _viewportService,
        _overlaysService,
        _canvasService,
      ];
}
