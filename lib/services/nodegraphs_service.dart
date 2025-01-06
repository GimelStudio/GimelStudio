import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/nodegraph.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:stacked/stacked.dart';

// TODO: rename to NodegraphService
class NodegraphsService extends ReactiveViewModel with ListenableServiceMixin {
  final _layersService = locator<LayersService>();

  NodegraphsService() {
    listenToReactiveValues([
      //selectedLayerIndex,
      nodegraph,
      nodes,
      selectedNode,
    ]);
  }

  NodeGraph? get nodegraph =>
      _layersService.layers.isEmpty ? null : _layersService.layers[_layersService.selectedLayerIndex].nodegraph;

  Map<String, NodeBase> get nodes =>
      _layersService.layers.isEmpty ? {} : _layersService.layers[_layersService.selectedLayerIndex].nodegraph.nodes;

  NodeBase? get selectedNode => nodes.values.isEmpty ? null : nodes.values.firstWhere((item) => item.selected == true);

  void selectNode(MapEntry<String, NodeBase> key) {
    // Deselect all nodes first.
    // for (MapEntry<String, NodeBase> item in nodes.entries) {
    //   item.value.selected = false;
    // }
    nodes[key.key]!.selected = true;
    notifyListeners();
    rebuildUi();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_layersService];
}
