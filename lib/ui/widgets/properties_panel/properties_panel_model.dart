import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/services/nodegraphs_service.dart';
import 'package:stacked/stacked.dart';

class PropertiesPanelModel extends ReactiveViewModel {
  final _layersService = locator<LayersService>();
  final _nodegraphsService = locator<NodegraphsService>();
  final _documentsService = locator<DocumentService>();

  NodeBase? get selectedNode => _nodegraphsService.selectedNode;

  void setPropertyValue(Property property, dynamic value) {
    _nodegraphsService.onEditNodePropertyValue(property, value);
    rebuildUi();
  }

  void onTogglePropertyExposed(Property property) {
    //print('${property.id}\n');
    property.isExposed = !property.isExposed;

    rebuildUi();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_nodegraphsService, _layersService, _documentsService];
}
