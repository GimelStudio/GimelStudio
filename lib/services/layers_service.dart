import 'dart:math' as math;

import 'package:gimelstudio/models/nodegraph.dart';
import 'package:gimelstudio/models/nodes.dart';
import 'package:stacked/stacked.dart';

import '../models/layer.dart';

class LayersService with ListenableServiceMixin {
  LayersService() {
    listenToReactiveValues([
      _selectedLayerIndex,
      _layers,
    ]);
  }

  int _selectedLayerIndex = 0;
  int get selectedLayerIndex => _selectedLayerIndex;

  List<Layer> _layers = [
    // TODO: remove these test layers
    Layer(
      id: 0,
      index: 0,
      name: 'Really long named layer 1',
      selected: true,
      visible: true,
      locked: false,
      opacity: 100,
      blend: BlendMode.normal,
      nodegraph: NodeGraph(
        id: 0,
        nodes: {
          'integer': IntegerNode(),
          'integer2': IntegerNode(),
          'add': AddNode(),
          'output': OutputNode(),
        },
      ),
    ),
    Layer(
      id: 1,
      index: 1,
      name: 'Layer 2',
      selected: false,
      visible: true,
      locked: false,
      opacity: 100,
      blend: BlendMode.normal,
      nodegraph: NodeGraph(
        id: 1,
        nodes: {
          'integer': IntegerNode(),
          'add': AddNode(),
          'output': OutputNode(),
        },
      ),
    ),
    Layer(
      id: 2,
      index: 2,
      name: 'Layer 3',
      selected: false,
      visible: true,
      locked: false,
      opacity: 100,
      blend: BlendMode.normal,
      nodegraph: NodeGraph(
        id: 2,
        nodes: {
          'integer': IntegerNode(),
          'integer2': IntegerNode(),
          'add': AddNode(),
          'output': OutputNode(),
        },
      ),
    ),
  ];
  List<Layer> get layers => _layers;

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
    math.Random random = math.Random(); // TODO: use uuid
    int randInt = random.nextInt(30003) + 89;
    print(_selectedLayerIndex);
    int insertAt = 0;
    if (layers.isNotEmpty) {
      insertAt = _selectedLayerIndex + 1;
    }
    _layers.insert(
      insertAt,
      Layer(
        id: randInt,
        index: layers.length + 1, // TODO
        name: 'New Layer #${layers.length + 1}',
        selected: layers.isNotEmpty ? false : true, // If this is the first layer it should be automatically selected
        visible: true,
        locked: false,
        opacity: 100,
        blend: BlendMode.normal,
        nodegraph: NodeGraph(
          id: layers.length + 1, // TODO
          nodes: {
            'integer': IntegerNode(),
            'output': OutputNode(),
          },
        ),
      ),
    );
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
