import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/nodegraph.dart';
import 'package:gimelstudio/models/nodes.dart';
import 'package:gimelstudio/services/id_service.dart';
import 'package:gimelstudio/services/node_registry_service.dart';
import 'package:stacked/stacked.dart';

import '../models/layer.dart';

class LayersService with ListenableServiceMixin {
  final _idService = locator<IdService>();
  final _nodeRegistryService = locator<NodeRegistryService>();

  LayersService() {
    listenToReactiveValues([
      _selectedLayerIndex,
      _layers,
    ]);
  }

  int _selectedLayerIndex = 0;
  int get selectedLayerIndex => _selectedLayerIndex;

  List<Layer> _layers = [];
  List<Layer> get layers => _layers;

  void initaddTestLayers() {
    // Layer(
    //   id: '0',
    //   index: 0,
    //   name: 'Really long named layer 1',
    //   selected: true,
    //   visible: true,
    //   locked: false,
    //   opacity: 100,
    //   blend: BlendMode.normal,
    //   nodegraph: NodeGraph(
    //     id: '0',
    //     nodes: {
    //       'integer': IntegerNode(),
    //       'integer2': IntegerNode(),
    //       'add': AddNode(),
    //       'output': OutputNode(),
    //     },
    //   ),
    // ),
  }

  void setSelectedLayer(Layer selectedLayer) {
    for (Layer layer in layers) {
      if (selectedLayer == layer) {
        layer.setSelected(true);
        _selectedLayerIndex = layers.indexOf(layer);
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
    final Layer item = layers.removeAt(oldIndex);
    _selectedLayerIndex = newIndex;
    _layers.insert(newIndex, item);
    print(layers);
    notifyListeners();
  }

  void addNewLayer() {
    print(_selectedLayerIndex);
    int insertAt = 0;
    if (layers.isNotEmpty) {
      insertAt = _selectedLayerIndex + 1;
    }

    // Default nodes
    // TODO: refactor
    Map<String, NodeBase> defaultNodes = {};
    NodeBase integerNode = _nodeRegistryService.createNode('integer_corenode', Offset(100, 80));
    integerNode.selected = true;
    defaultNodes[integerNode.id] = integerNode;
    NodeBase outputNode = _nodeRegistryService.createNode('output_corenode', Offset(410, 80));
    defaultNodes[outputNode.id] = outputNode;

    _layers.insert(
      insertAt,
      Layer(
        id: _idService.newId(),
        index: layers.length + 1, // TODO: need to update indexes when reordering layers
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
    notifyListeners();
  }

  // TODO: deleting middle layers is buggy
  void deleteLayer() {
    // Delete the selected layer
    print('-----selected layer index: $selectedLayerIndex');
    print('layers: $layers');

    if (layers.isNotEmpty) {
      // First de-select the current layer.
      layers.elementAt(selectedLayerIndex).setSelected(false);

      int newSelectedIndex = 0;

      // If this is the last layer, there will be no selection.
      if (selectedLayerIndex == 0 && layers.length == 1) {
        newSelectedIndex = 0;
        print('one');
      } else if (selectedLayerIndex == layers.indexOf(layers.last) && layers.length >= 2) {
        // If the selected layer is the last in the stack, select the next layer above.
        newSelectedIndex = selectedLayerIndex - 1;
        print('last');
      } else if (selectedLayerIndex == layers.indexOf(layers.first) && layers.length >= 2) {
        // If the selected layer is the first in the stack, select the next layer below.
        newSelectedIndex = selectedLayerIndex + 1;
        print('first');
      } else if (selectedLayerIndex != 0 && selectedLayerIndex != layers.indexOf(layers.last) && layers.length >= 2) {
        // // if the selected layer in in the middle of the stack, select the next layer below until there are none below to select.
        // //if (selectedLayerIndex > layers.indexOf(layers.last)) {
        // newSelectedIndex = selectedLayerIndex + 1;
        // // } else {
        // //   newSelectedIndex = selectedLayerIndex - 1;
        // // }

        print('middle');
      } else {
        print('else');
      }

      //print(newSelectedIndex);
      layers.elementAt(newSelectedIndex).setSelected(true);

      // // Delete the selected layer
      layers.removeAt(selectedLayerIndex);

      _selectedLayerIndex = newSelectedIndex;
    } else {
      _selectedLayerIndex = 0;
    }
    notifyListeners();
  }
}
