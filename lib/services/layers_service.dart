import 'dart:ui';

import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/nodegraph.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/id_service.dart';
import 'package:gimelstudio/services/node_registry_service.dart';
import 'package:stacked/stacked.dart';

import '../models/layer.dart';

class LayersService with ListenableServiceMixin {
  final _idService = locator<IdService>();
  final _documentsService = locator<DocumentService>();
  final _nodeRegistryService = locator<NodeRegistryService>();

  LayersService() {
    listenToReactiveValues([
      selectedLayerIndex,
      selectedLayer,
      layers,
    ]);
  }

  int get selectedLayerIndex => layers.isEmpty ? 0 : layers.indexWhere((item) => item.selected == true);

  Layer? get selectedLayer => layers.isEmpty ? null : layers[selectedLayerIndex];

  List<Layer> get layers =>
      _documentsService.selectedDocument == null ? [] : _documentsService.selectedDocument!.layers;

  void setSelectedLayer(Layer selectedLayer) {
    for (Layer layer in layers) {
      if (selectedLayer == layer) {
        layer.setSelected(true);
      } else {
        layer.setSelected(false);
      }
    }
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

  Layer addNewLayer({String type = 'rectangle'}) {
    int insertAt = 0;
    if (layers.isNotEmpty) {
      // Note for the future: Layers are added underneath the selected layer.
      // When working with a vector layer stack, the next layer
      // would be placed above the current layer rather than underneath.
      insertAt = selectedLayerIndex + 1;
    }

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

    Node outputNode = layerNodes.values.firstWhere((item) => item.isOutput == true);

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

  /// Delete the selected layer.
  void deleteLayer() {
    int oldSelectedLayerIndex = selectedLayerIndex;

    if (layers.isNotEmpty) {
      int newSelectedIndex = 0;

      // If this is the last layer, there will be no selection.
      if (selectedLayerIndex == 0 && layers.length == 1) {
        newSelectedIndex = 0;
      } else if (oldSelectedLayerIndex == layers.indexOf(layers.last)) {
        // If the selected layer is the last in the stack, select the next layer above.
        newSelectedIndex = oldSelectedLayerIndex - 1;
      } else if (oldSelectedLayerIndex == layers.indexOf(layers.first)) {
        // If the selected layer is the first in the stack, select the next layer below.
        newSelectedIndex = oldSelectedLayerIndex + 1;
      } else if (oldSelectedLayerIndex != 0 &&
          oldSelectedLayerIndex != layers.indexOf(layers.last) &&
          oldSelectedLayerIndex != layers.indexOf(layers.first) &&
          layers.length >= 2) {
        // if the selected layer in in the middle of the stack, select the
        // next layer below it until there are none below to select.
        newSelectedIndex = oldSelectedLayerIndex + 1;
      }

      // Select the other layer.
      setSelectedLayer(layers.firstWhere((item) => layers.indexOf(item) == newSelectedIndex));

      // Finally delete the selected layer.
      layers.removeAt(oldSelectedLayerIndex);
    }
    notifyListeners();
  }

  void renameLayer() {
    notifyListeners();
  }

  /// Re-sync the Layer Object indexes with the indexes in the layer stack list.
  void syncLayerIndexes() {
    for (Layer layer in layers) {
      layer.index = layers.indexOf(layer);
    }
  }
}
