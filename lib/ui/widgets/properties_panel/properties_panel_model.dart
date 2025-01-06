import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/services/image_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/services/nodegraphs_service.dart';
import 'package:stacked/stacked.dart';

class PropertiesPanelModel extends ReactiveViewModel {
  final _imageService = locator<ImageService>();
  final _layersService = locator<LayersService>();
  final _nodegraphsService = locator<NodegraphsService>();
  // Map<String, NodeBase> get nodes =>
  //     _layersService.layers.isEmpty ? {} : _layersService.layers[_layersService.selectedLayerIndex].nodegraph.nodes;

  // NodeBase? get selectedNode => nodes.values.isEmpty ? null : nodes.values.firstWhere((item) => item.selected == true);
  NodeBase? get selectedNode => _nodegraphsService.selectedNode;

  void setPropertyValue(Property property, dynamic value) {
    property.value = value;
    notifyListeners();
  }

  void onTogglePropertyExposed(Property property) {
    property.isExposed = !property.isExposed;
    notifyListeners();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_nodegraphsService];
}
