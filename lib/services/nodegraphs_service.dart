import 'dart:ui';

import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/models/nodegraph.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:stacked/stacked.dart';

// TODO: rename to NodegraphService
class NodegraphsService extends ReactiveViewModel with ListenableServiceMixin {
  final _layersService = locator<LayersService>();

  NodegraphsService() {
    listenToReactiveValues([
      nodegraph,
      nodes,
      selectedNode,
    ]);
  }

  NodeGraph? get nodegraph => _layersService.layers.isEmpty ? null : _layersService.selectedLayer?.nodegraph;

  Map<String, Node> get nodes => nodegraph == null ? {} : nodegraph!.nodes;

  Node? get selectedNode => nodes.values.isEmpty ? null : nodes.values.firstWhere((item) => item.selected == true);

  void selectNode(Node node) {
    nodes[node.id]?.selected = true;
    notifyListeners();
  }

  void moveNode(Node node, Offset newPosition) {
    // Deselect all nodes first.
    for (MapEntry<String, Node> item in nodes.entries) {
      item.value.selected = false;
    }

    nodes[node.id]?.selected = true;
    nodes[node.id]?.position = newPosition;
    notifyListeners();
  }

  void onEditNodePropertyValue(Property property, dynamic value) {
    property.value = value;
    notifyListeners();
  }

  void onSetPropertyExposed(Property property, bool isExposed) {
    property.isExposed = isExposed;
    notifyListeners();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_layersService];
}
