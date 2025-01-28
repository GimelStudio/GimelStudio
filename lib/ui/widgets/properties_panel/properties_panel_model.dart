import 'dart:async';
import 'dart:ui';

import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/services/nodegraphs_service.dart';
import 'package:stacked/stacked.dart';

class PropertiesPanelModel extends ReactiveViewModel {
  final _layersService = locator<LayersService>();
  final _nodegraphsService = locator<NodegraphsService>();
  final _documentService = locator<DocumentService>();
  final _evaluationService = locator<EvaluationService>();

  Node? get selectedNode => _nodegraphsService.selectedNode;

  Document? get selectedDocument => _documentService.selectedDocument;
  Layer? get selectedLayer => _layersService.selectedLayer;

  void setPropertyValue(Property property, dynamic value) {
    selectedLayer?.needsEvaluation = true;
    _nodegraphsService.onEditNodePropertyValue(property, value);
    _evaluationService.evaluate();
    rebuildUi();
  }

  void onTogglePropertyExposed(Property property) {
    _nodegraphsService.onSetPropertyExposed(property, !property.isExposed);
    rebuildUi();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_nodegraphsService, _layersService, _documentService];
}
