import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:gimelstudio/services/image_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/services/export_service.dart';
import 'package:gimelstudio/ui/widgets/viewport_panel/viewport_panel.dart';

import '../../../app/app.locator.dart';
import 'package:stacked/stacked.dart';

class ViewportPanelModel extends ReactiveViewModel {
  final _imageService = locator<ImageService>();
  final _evaluationService = locator<EvaluationService>();
  final _layersService = locator<LayersService>();
  final _exportService = locator<ExportService>();

  List<CanvasItem>? get result => _evaluationService.result;

  List<CanvasItem> get items => result == null ? [] : result ?? [];

  CanvasItem? get selectedItem => items.isEmpty ? null : items[_layersService.selectedLayerIndex];

  Offset? _draggingStartPosition;
  Offset? get draggingStartPosition => _draggingStartPosition;
  Offset? _draggingInitialNodePosition;
  Offset? get draggingInitialNodePosition => _draggingInitialNodePosition;

  void onPanDown(DragDownDetails event) {
    if (selectedItem != null) {
      _draggingStartPosition = event.localPosition;
      //_draggingInitialNodePosition = Offset(selectedItem!.x, selectedItem!.y);
    }

    rebuildUi();
  }

  void onPanUpdate(DragUpdateDetails event) {
    if (selectedItem != null && _draggingStartPosition != null && _draggingInitialNodePosition != null) {
      Offset pos = draggingInitialNodePosition! + event.localPosition - draggingStartPosition!;
      // selectedItem!.x = pos.dx;
      // selectedItem!.y = pos.dy;
    }
    rebuildUi();
  }

  void onPanCancel() {
    //onNodeMoved(draggingInitialNodePosition!);

    _draggingStartPosition = null;
    _draggingInitialNodePosition = null;
    rebuildUi();
  }

  void onPanEnd(DragEndDetails event) {
    _draggingStartPosition = null;
    _draggingInitialNodePosition = null;

    rebuildUi();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_imageService, _evaluationService];
}
