import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:stacked/stacked.dart';

class LayersPanelModel extends ReactiveViewModel {
  final _layersService = locator<LayersService>();

  List<Layer> get layers => _layersService.layers;

  void onSelectLayer(Layer layer) {
    _layersService.setSelectedLayer(layer);
  }

  void onToggleLayerVisibility(Layer layer) {
    _layersService.setLayerVisibility(layer, !layer.visible);
  }

  void onToggleLayerLocked(Layer layer) {
    _layersService.setLayerLocked(layer, !layer.locked);
  }

  void onReorderLayers(int oldIndex, int newIndex) {
    _layersService.reorderLayers(oldIndex, newIndex);
  }

  void onAddNewLayer() {
    _layersService.addNewLayer();
  }

  void onDeleteLayer() {
    _layersService.deleteLayer();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_layersService];
}
