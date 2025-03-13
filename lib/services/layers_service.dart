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

  void setLayerBlendMode(Layer layer, String blendMode) {
    layer.blend = blendMode;
    notifyListeners();
  }

  void setLayerOpacity(Layer layer, int opacity) {
    layer.opacity = opacity;
    notifyListeners();
  }

  void setLayerVisibility(Layer layer, bool isVisible) {
    layer.setVisibility(isVisible);
    notifyListeners();
  }

  void setLayersVisible(List<Layer> layers) {
    for (Layer layer in layers) {
      layer.setVisibility(true);
    }
    notifyListeners();
  }

  void setLayersHidden(List<Layer> layers) {
    for (Layer layer in layers) {
      layer.setVisibility(false);
    }
    notifyListeners();
  }

  void setLayerLock(Layer layer, bool isLocked) {
    layer.setLocked(isLocked);
    setLayerSelected(layer);
    notifyListeners();
  }

  void setLayersLocked(List<Layer> layers) {
    for (Layer layer in layers) {
      layer.setLocked(true);
    }
    notifyListeners();
  }

  void setLayersUnlocked(List<Layer> layers) {
    for (Layer layer in layers) {
      layer.setLocked(false);
    }
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

  /// Add a new layer of [type] to the layer stack.
  Layer addNewLayer({String type = 'rectangle'}) {
    // When working with a vector layer stack, the next layer
    // is placed above the current layer.
    int insertAt = 0;

    // Default nodes
    // TODO: refactor
    Map<String, Node> defaultNodes = _nodeRegistryService.newDefaultNodes(type, 'Untitled ${layers.length + 1}');

    Layer newLayer = Layer(
      id: _idService.newId(),
      index: layers.length + 1,
      name: 'Untitled ${layers.length + 1}',
      selected: layers.isNotEmpty ? false : true, // If this is the first layer it should be automatically selected
      visible: true,
      locked: false,
      opacity: 100,
      blend: 'Normal',
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
      //Node blurNode = layerNodes.values.firstWhere((item) => item.idname == 'blur_corenode');
      Node imageNode = layerNodes.values.firstWhere((item) => item.idname == 'image_corenode');

      //blurNode.setConnection('photo', photoNode, 'output');

      imageNode.setConnection('photo', photoNode, 'output');

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
