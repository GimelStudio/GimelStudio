import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/layer.dart';
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

  List<Layer> get layers => _layersService.layers;

  // When an item is selected on the canvas, the layer should be selected

  Node? itemNode;

  void setPropertyValue(Property property, dynamic value) {
    _nodegraphsService.onEditNodePropertyValue(property, value);
  }

  void setItemNode(Offset position) {
    for (CanvasItem item in items) {
      if (item.isInside(position) == true) {
        print('$item');
        List<Layer> documentLayers = List.from(layers.where((item) => item.visible == true));
        documentLayers.sort((Layer a, Layer b) => b.index.compareTo(a.index));

        Layer layer = documentLayers.firstWhere((layer) => layer.id == item.layerId);

        // TODO: this assumes there is only one CanvasItem node in the nodegraph
        itemNode = layer.nodegraph.nodes.values.firstWhere((node) => node.idname == '${item.type}_corenode');
        _layersService.setSelectedLayer(layer);
        break;
      } else {
        itemNode = null;
      }
    }
  }

  Offset? _draggingStartPosition;
  Offset? get draggingStartPosition => _draggingStartPosition;
  Offset? _draggingInitialNodePosition;
  Offset? get draggingInitialNodePosition => _draggingInitialNodePosition;

  void onTapDown(TapDownDetails event) {
    print('onTapDown');
    setItemNode(event.localPosition);
    rebuildUi();
  }

  void onPanDown(DragDownDetails event) {
    setItemNode(event.localPosition);

    if (itemNode != null) {
      _draggingStartPosition = event.localPosition;

      var xProp = itemNode?.properties.values.firstWhere((item) => item.idname == 'x');
      var yProp = itemNode?.properties.values.firstWhere((item) => item.idname == 'y');

      _draggingInitialNodePosition = Offset(xProp!.value as double, yProp!.value as double);
    }

    rebuildUi();
  }

  void onPanUpdate(DragUpdateDetails event) {
    if (itemNode != null && _draggingStartPosition != null && _draggingInitialNodePosition != null) {
      Offset pos = draggingInitialNodePosition! + event.localPosition - draggingStartPosition!;

      var xProp = itemNode?.properties.values.firstWhere((item) => item.idname == 'x');
      var yProp = itemNode?.properties.values.firstWhere((item) => item.idname == 'y');

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
