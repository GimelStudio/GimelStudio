import 'package:gimelstudio/app/app.locator.dart';
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

  List<Layer> get selectedLayers => _layersService.selectedLayers;

  List<Property> getProperties() {
    if (selectedNode == null) {
      return [];
    }

    List<Property> properties = List.from(selectedNode!.properties.values);
    for (Property property in selectedNode!.properties.values) {
      // Remove common Canvas Item properties since they are handled seperately.
      List<String> commonCanvasItemPropertyIdnames = ['x', 'y', 'width', 'height', 'rotation', 'border_radius'];
      if (selectedNode?.isCanvasItemNode == true && commonCanvasItemPropertyIdnames.contains(property.idname)) {
        properties.remove(property);
      }
    }

    return properties;
  }

  void setPropertyValue(Property property, dynamic value, {bool evaluate = true}) {
    for (Layer layer in selectedLayers) {
      layer.needsEvaluation = true;
    }
    _nodegraphsService.onEditNodePropertyValue(property, value);
    if (evaluate == true) {
      _evaluationService.evaluate();
      rebuildUi();
    }
  }

  void onTogglePropertyExposed(Property property) {
    _nodegraphsService.onSetPropertyExposed(property, !property.isExposed);
    rebuildUi();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_nodegraphsService, _layersService, _documentService];
}
