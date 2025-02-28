import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/models/photo.dart';
import 'package:gimelstudio/models/tool.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/services/nodegraphs_service.dart';

class ImageToolService implements ToolModeEventHandler {
  final _layersService = locator<LayersService>();
  final _evaluationService = locator<EvaluationService>();
  final _nodegraphsService = locator<NodegraphsService>();
  final _documentService = locator<DocumentService>();

  Offset? draggingStartPosition;
  Offset? lastPosition;

  List<Layer> get layers => _layersService.layers;
  List<Layer> get selectedLayers => _layersService.selectedLayers;

  List<CanvasItem> get items => _documentService.activeDocument?.result ?? [];

  Photo? photo;
  int photoWidth = 0;
  int photoHeight = 0;

  // Aspect ratio is locked by default.
  bool lockAspectRatio = true;

  @override
  void activate() async {
    // TODO: will need to refactor this code.
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpg', 'png'],
    );
    final XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

    if (file == null) {
      return;
    }

    Uint8List bytes = await file.readAsBytes();
    photo = Photo(filePath: file.path, data: bytes);

    photo?.uiData = await photo?.toCanvasImageData();
    photoWidth = photo?.uiData!.width ?? 0;
    photoHeight = photo?.uiData!.height ?? 0;
  }

  @override
  void deactivate() {
    photo = null;
  }

  @override
  void onHover(PointerHoverEvent event) {}

  @override
  void onTapDown(TapDownDetails event) {}

  @override
  void onPanDown(DragDownDetails event) {
    if (photo == null) {
      return;
    }

    Layer layer = _layersService.addNewLayer(type: 'image');

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

    // It should be okay to assume that there is only one photo_corenode since the layer was just created.
    Node photoNode = layer.nodegraph.nodes.values.firstWhere((item) => item.idname == 'photo_corenode');
    Property imageProp = photoNode.getPropertyByIdname('photo');
    _nodegraphsService.onEditNodePropertyValue(imageProp, photo);

    lastPosition = event.localPosition;

    _evaluationService.evaluate(evaluateLayers: selectedLayers);
  }

  @override
  void onPanUpdate(DragUpdateDetails event) {
    if (selectedLayers.isEmpty || draggingStartPosition == null || lastPosition == null || photo == null) {
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

        double newWidth = widthProp.value + (pos.dx);
        double newHeight = heightProp.value + (pos.dy);

        if (lockAspectRatio == true) {
          double aspectRatio = photoWidth / photoHeight;

          newHeight = newWidth / aspectRatio;
        }

        _nodegraphsService.onEditNodePropertyValue(widthProp, newWidth);
        _nodegraphsService.onEditNodePropertyValue(heightProp, newHeight);

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
