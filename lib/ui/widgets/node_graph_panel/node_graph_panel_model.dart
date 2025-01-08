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

  Map<String, NodeBase> get nodes => _nodegraphsService.nodegraph == null ? {} : _nodegraphsService.nodegraph!.nodes;

  void onSelectNode(NodeBase node) {
    _nodegraphsService.selectNode(node);
  }

  // TODO: move work to service
  void onNodeMoved(NodeBase node, Offset newPosition) {
    _nodegraphsService.moveNode(node, newPosition);
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_layersService, _documentsService];
}
