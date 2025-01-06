import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/services/node_registry_service.dart';
import 'package:gimelstudio/services/nodegraphs_service.dart';
import 'package:stacked/stacked.dart';

class NodeGraphPanelModel extends ReactiveViewModel {
  final _layersService = locator<LayersService>();
  final _documentsService = locator<DocumentService>();
  final _nodeRegistryService = locator<NodeRegistryService>();
  final _nodegraphsService = locator<NodegraphsService>();

  Map<String, NodeBase> get nodeRegistry => _nodeRegistryService.nodeRegistry;

  // TODO: Maybe create a currentLayer (object)?
  Map<String, NodeBase> get nodes =>
      _layersService.layers.isEmpty ? {} : _layersService.layers[_layersService.selectedLayerIndex].nodegraph.nodes;

  void onSelectNode(MapEntry<String, NodeBase> key) {
    _nodegraphsService.selectNode(key);
    notifyListeners();
  }

  // TODO: move work to service
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
  List<ListenableServiceMixin> get listenableServices => [_layersService, _documentsService];
}
