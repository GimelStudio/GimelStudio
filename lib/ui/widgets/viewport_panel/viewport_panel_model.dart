import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:gimelstudio/services/image_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/services/export_service.dart';
import 'package:gimelstudio/services/nodegraphs_service.dart';
import 'package:gimelstudio/ui/widgets/viewport_panel/viewport_panel.dart';

import '../../../app/app.locator.dart';
import 'package:stacked/stacked.dart';

class ViewportPanelModel extends ReactiveViewModel {
  final _imageService = locator<ImageService>();
  final _evaluationService = locator<EvaluationService>();
  final _layersService = locator<LayersService>();
  final _exportService = locator<ExportService>();
  final _nodegraphsService = locator<NodegraphsService>();

  List<CanvasItem>? get result => _evaluationService.result;

  List<CanvasItem> get items => result == null ? [] : result ?? [];

  CanvasItem? get selectedItem => items.isEmpty ? null : items[_layersService.selectedLayerIndex];

  // When an item is selected on the canvas, the layer should be selected

  Node? get selectedNode => _nodegraphsService.selectedNode;

  void setPropertyValue(Property property, dynamic value) {
    _nodegraphsService.onEditNodePropertyValue(property, value);
  }

  Offset? _draggingStartPosition;
  Offset? get draggingStartPosition => _draggingStartPosition;
  Offset? _draggingInitialNodePosition;
  Offset? get draggingInitialNodePosition => _draggingInitialNodePosition;

  void onTapDown(TapDownDetails event) {
    // for (var item in items) {
    //   if (item.isInside(event.localPosition) == true) {
    //     selectedItem = item;
    // Need to get node from canvasitem
    //   }
    // }
  }

  void onPanDown(DragDownDetails event) {
    if (selectedNode != null) {
      _draggingStartPosition = event.localPosition;

      var xProp = selectedNode?.properties.values.firstWhere((item) => item.idname == 'x');
      var yProp = selectedNode?.properties.values.firstWhere((item) => item.idname == 'y');

      _draggingInitialNodePosition = Offset(xProp!.value as double, yProp!.value as double);
    }

    rebuildUi();
  }

  void onPanUpdate(DragUpdateDetails event) {
    if (selectedNode != null && _draggingStartPosition != null && _draggingInitialNodePosition != null) {
      Offset pos = draggingInitialNodePosition! + event.localPosition - draggingStartPosition!;

      var xProp = selectedNode?.properties.values.firstWhere((item) => item.idname == 'x');
      var yProp = selectedNode?.properties.values.firstWhere((item) => item.idname == 'y');

      setPropertyValue(xProp!, pos.dx);
      setPropertyValue(yProp!, pos.dy);
      _evaluationService.evaluate();
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
