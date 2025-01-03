import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/nodes.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/services/nodegraphs_service.dart';
import 'package:stacked/stacked.dart';

class NodeGraphPanelModel extends ReactiveViewModel {
  final _layersService = locator<LayersService>();
  final _nodegraphsService = locator<NodegraphsService>();

  // TODO: Maybe create a currentLayer (object)?
  Map<String, NodeBase> get nodes => _layersService.layers[_layersService.selectedLayerIndex].nodegraph.nodes;

  // TODO: move work to service
  void onSelectNode(MapEntry<String, NodeBase> key) {
    // Deselect all nodes first.
    for (MapEntry<String, NodeBase> item in nodes.entries) {
      item.value.selected = false;
    }
    nodes[key.key]?.selected = true;
    rebuildUi();
  }

  void onNodeMoved(MapEntry<String, NodeBase> key, Offset newPosition) {
    // Deselect all nodes first.
    for (MapEntry<String, NodeBase> item in nodes.entries) {
      item.value.selected = false;
    }

    nodes[key.key]?.selected = true;
    nodes[key.key]?.position = newPosition;
    rebuildUi();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_layersService];
}
