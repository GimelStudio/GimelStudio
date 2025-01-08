import 'package:flutter/material.dart';
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
      selectedDocumentIndex,
      selectedLayerIndex,
      layers,
    ]);
  }

  int get selectedDocumentIndex => _documentsService.selectedDocumentIndex;

  int get selectedLayerIndex => layers.isEmpty ? 0 : layers.indexWhere((item) => item.selected == true);

  List<Layer> get layers =>
      _documentsService.documents.isEmpty ? [] : _documentsService.documents[selectedDocumentIndex].layers;

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
    print(layers);
    notifyListeners();
  }

  void addNewLayer() {
    int insertAt = 0;
    if (layers.isNotEmpty) {
      // Note for the future: Layers are added underneath the selected layer.
      // When working with a vector layer stack, the next layer
      // would be placed above the current layer rather than underneath.
      insertAt = selectedLayerIndex + 1;
    }

    // Default nodes
    // TODO: refactor
    Map<String, NodeBase> defaultNodes = {};

    NodeBase integerNode = _nodeRegistryService.createNode('integer_corenode', Offset(100, 80));
    integerNode.selected = true;
    defaultNodes[integerNode.id] = integerNode;

    NodeBase addNode = _nodeRegistryService.createNode('add_corenode', Offset(200, 80));
    defaultNodes[addNode.id] = addNode;

    NodeBase outputNode = _nodeRegistryService.createNode('output_corenode', Offset(410, 80));
    defaultNodes[outputNode.id] = outputNode;

    layers.insert(
      insertAt,
      Layer(
        id: _idService.newId(),
        index: layers.length + 1,
        name: 'Untitled ${layers.length + 1}',
        selected: layers.isNotEmpty ? false : true, // If this is the first layer it should be automatically selected
        visible: true,
        locked: false,
        opacity: 100,
        blend: BlendMode.normal,
        nodegraph: NodeGraph(
          id: _idService.newId(),
          nodes: defaultNodes,
        ),
      ),
    );
    //print(layers);
    syncLayerIndexes();
    notifyListeners();
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
