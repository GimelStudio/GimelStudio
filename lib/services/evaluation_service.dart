import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/renderer.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:stacked/stacked.dart';

class EvaluationService with ListenableServiceMixin {
  final _layersService = locator<LayersService>();

  EvaluationService() {
    listenToReactiveValues([
      layers,
      _result,
    ]);
  }

  List<Layer> get layers => _layersService.layers;

  List<Rectangle> _result = [];
  List<Rectangle> get result => _result;

  void evaluate() {
    List<Rectangle> finalResult = [];
    if (layers.isNotEmpty) {
      // Sort layers and exclude hidden
      List<Layer> documentLayers = List.from(layers.where((item) => item.visible == true));
      documentLayers.sort((Layer a, Layer b) => b.index.compareTo(a.index));

      for (Layer layer in documentLayers) {
        Map<String, NodeBase> layerNodes = layer.nodegraph.nodes;

        NodeBase outputNode = layerNodes.values.firstWhere((item) => item.isOutput == true);
        NodeBase rectNode = layerNodes.values.firstWhere((item) => item.idname == 'rectangle_corenode');
        // TODO
        outputNode.setConnection('layer', rectNode, 'output');
        //print(outputNode.connectedNode);
        //print(firstLayerNodes);

        Renderer renderer = Renderer(nodes: layerNodes);
        Rectangle result = renderer.render('output_corenode');
        result.opacity = (layer.opacity * 2.55).toInt();
        print(result.opacity);
        finalResult.add(result);
      }
    }
    _result = finalResult;
    notifyListeners();
  }
}
