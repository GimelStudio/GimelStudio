import 'dart:ui';

import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/nodegraph.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/id_service.dart';
import 'package:gimelstudio/services/node_registry_service.dart';
import 'package:stacked/stacked.dart';

import '../models/layer.dart';

/// The layer stack is from bottom up:
/// ...
/// 3
/// 2
/// 1
/// 0
///
/// Layers are always inserted at the top.

class LayersService with ListenableServiceMixin {
  final _idService = locator<IdService>();
  final _documentsService = locator<DocumentService>();
  final _nodeRegistryService = locator<NodeRegistryService>();

  LayersService() {
    listenToReactiveValues([
      selectedLayers,
      layers,
    ]);
  }

  List<Layer> get selectedLayers =>
      _documentsService.activeDocument == null ? [] : _documentsService.activeDocument!.selectedLayers;

  List<Layer> get layers => _documentsService.activeDocument == null ? [] : _documentsService.activeDocument!.layers;

  void setLayerSelected(Layer selectedLayer) {
    selectedLayers.clear();
    selectedLayers.add(selectedLayer);
    notifyListeners();
  }

  void addLayerToSelected(Layer layer) {
    selectedLayers.add(layer);
    notifyListeners();
  }

  void removeFromSelected(Layer layer) {
    selectedLayers.remove(layer);
    notifyListeners();
  }

  void deselectAllLayers() {
    selectedLayers.clear();
    notifyListeners();
  }

  void setLayerVisibility(Layer layer, bool isVisible) {
    layer.setVisibility(isVisible);
    notifyListeners();
  }

  void setLayerLocked(Layer layer, bool isLocked) {
    layer.setLocked(isLocked);
    notifyListeners();
  }

  void reorderLayers(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      // This is necessary because of a bug
      // in the Flutter widget.
      newIndex -= 1;
    }
    final Layer layer = layers.removeAt(oldIndex);
    layers.insert(newIndex, layer);

    syncLayerIndexes();
    //print(layers);
    notifyListeners();
  }

  Map<String, Node> newDefaultNodes(String type, String outputLabel) {
    Map<String, Node> defaultNodes = {};

    if (type == 'rectangle') {
      Node rectangleNode = _nodeRegistryService.createNode('rectangle_corenode', Offset(200, 80));
      rectangleNode.selected = true;
      defaultNodes[rectangleNode.id] = rectangleNode;
    } else if (type == 'image') {
      Node photoNode = _nodeRegistryService.createNode('photo_corenode', Offset(120, 80));
      defaultNodes[photoNode.id] = photoNode;

      Node blurNode = _nodeRegistryService.createNode('blur_corenode', Offset(110, 80));
      defaultNodes[blurNode.id] = blurNode;

      Node imageNode = _nodeRegistryService.createNode('image_corenode', Offset(100, 80));
      imageNode.selected = true;
      defaultNodes[imageNode.id] = imageNode;
    } else if (type == 'text') {
      Node textNode = _nodeRegistryService.createNode('text_corenode', Offset(300, 80));
      textNode.selected = true;
      defaultNodes[textNode.id] = textNode;
    }

    Node outputNode = _nodeRegistryService.createNode('output_corenode', Offset(410, 80));
    defaultNodes[outputNode.id] = outputNode;
    outputNode.label = outputLabel; // TODO: need to keep this in sync with the layer name

    return defaultNodes;
  }

  /// Add a new layer of [type] to the layer stack.
  Layer addNewLayer({String type = 'rectangle'}) {
    // When working with a vector layer stack, the next layer
    // is placed above the current layer.
    int insertAt = 0;

    // Default nodes
    // TODO: refactor
    Map<String, Node> defaultNodes = newDefaultNodes(type, 'Untitled ${layers.length + 1}');

    Layer newLayer = Layer(
      id: _idService.newId(),
      index: layers.length + 1,
      name: 'Untitled ${layers.length + 1}',
      selected: layers.isNotEmpty ? false : true, // If this is the first layer it should be automatically selected
      visible: true,
      locked: false,
      opacity: 100,
      blend: LayerBlendMode.normal,
      nodegraph: NodeGraph(
        id: _idService.newId(),
        nodes: defaultNodes,
      ),
    );

    // Automatically connect nodes
    Map<String, Node> layerNodes = newLayer.nodegraph.nodes;

    Node outputNode = layerNodes.values.firstWhere((item) => item.isLayerOutput == true);

    if (type == 'image') {
      Node photoNode = layerNodes.values.firstWhere((item) => item.idname == 'photo_corenode');
      Node blurNode = layerNodes.values.firstWhere((item) => item.idname == 'blur_corenode');
      Node imageNode = layerNodes.values.firstWhere((item) => item.idname == 'image_corenode');

      blurNode.setConnection('photo', photoNode, 'output');

      imageNode.setConnection('photo', blurNode, 'output');

      outputNode.setConnection('layer', imageNode, 'output');
    } else {
      Node inNode = layerNodes.values.firstWhere((item) => item.idname == '${type}_corenode');

      outputNode.setConnection('layer', inNode, 'output');
    }

    layers.insert(
      insertAt,
      newLayer,
    );

    //print(layers);
    syncLayerIndexes();
    notifyListeners();
    return newLayer;
  }

  /// Delete the selected layers [selectedLayers].
  void deleteLayers(List<Layer> selectedLayers) {
    List<Layer> layersToDelete = List.of(selectedLayers);

    deselectAllLayers();

    for (Layer layer in layersToDelete) {
      layers.removeWhere((l) => layer.id == l.id);
    }
    syncLayerIndexes();
    notifyListeners();
  }

  /// Rename the [layer] as [newName].
  void renameLayer(Layer layer, String newName) {
    layer.name = newName;

    notifyListeners();
  }

  /// Re-sync the Layer Object indexes with the indexes in the layer stack list.
  void syncLayerIndexes() {
    for (Layer layer in layers) {
      layer.index = layers.indexOf(layer);
    }
  }

  Node? canvasItemNodeFromLayer(Layer layer) {
    // This assumes there is only one CanvasItem node in the nodegraph.
    return layer.nodegraph.nodes.values.firstWhere((node) => node.isCanvasItemNode == true);
  }

  Layer? getLayerFromPosition(Offset position, List<CanvasItem> items, List<Layer> layers) {
    CanvasItem? item =
        items.cast<CanvasItem?>().lastWhere((CanvasItem? item) => item!.isInside(position), orElse: () => null);

    if (item != null) {
      List<Layer> documentLayers = List.from(layers.where((item) => item.visible == true));
      return documentLayers.firstWhere((layer) => layer.id == item.layerId);
    } else {
      return null;
    }
  }
}
