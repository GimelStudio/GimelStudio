import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/services/nodegraphs_service.dart';
import 'package:stacked/stacked.dart';

class LayersPanelModel extends ReactiveViewModel {
  final _layersService = locator<LayersService>();
  final _documentsService = locator<DocumentService>();
  final _nodegraphsService = locator<NodegraphsService>();
  final _evaluationService = locator<EvaluationService>();

  List<Layer> get layers => _layersService.layers;
  List<Layer> get selectedLayers => _layersService.selectedLayers;

  bool get isLayerBlendModeDropdownEnabled => selectedLayers.isNotEmpty && selectedLayers.length <= 1;
  bool get isLayerOpacitySliderEnabled => selectedLayers.isNotEmpty && selectedLayers.length <= 1;
  bool get isAddNewLayerBtnEnabled => true;
  bool get isDeleteLayerBtnEnabled => selectedLayers.isNotEmpty;

  void onChangeLayerOpacity(int opacity) {
    _layersService.setLayerOpacity(selectedLayers.first, opacity);
    _evaluationService.evaluate(evaluateLayers: [selectedLayers.first]);
  }

  void onSelectLayer(Layer layer) {
    _layersService.setLayerSelected(layer);
  }

  void onToggleLayerVisibility(Layer layer) {
    _layersService.setLayerVisibility(layer, !layer.visible);
    _evaluationService.evaluate();
  }

  void onToggleLayerLocked(Layer layer) {
    _layersService.setLayerLocked(layer, !layer.locked);
  }

  void onReorderLayers(int oldIndex, int newIndex) {
    _layersService.reorderLayers(oldIndex, newIndex);
    _evaluationService.evaluate();
  }

  void onAddNewLayer() {
    _layersService.addNewLayer();
    _evaluationService.evaluate();
  }

  void onDeleteLayer() {
    _layersService.deleteLayers(selectedLayers);
    _evaluationService.evaluate();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_layersService, _nodegraphsService, _documentsService];
}
