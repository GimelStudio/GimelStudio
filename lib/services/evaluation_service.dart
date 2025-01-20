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

  List<CanvasItem> _result = [];
  List<CanvasItem> get result => _result;

  void evaluate() {
    List<CanvasItem> finalResult = [];
    if (layers.isNotEmpty) {
      // Sort layers and exclude hidden
      List<Layer> documentLayers = List.from(layers.where((item) => item.visible == true));
      documentLayers.sort((Layer a, Layer b) => b.index.compareTo(a.index));

      for (Layer layer in documentLayers) {
        Map<String, Node> layerNodes = layer.nodegraph.nodes;

        Node outputNode = layerNodes.values.firstWhere((item) => item.isOutput == true);
        Node inNode;
        if (layer.index == 0) {
          inNode = layerNodes.values.firstWhere((item) => item.idname == 'text_corenode');
        } else {
          inNode = layerNodes.values.firstWhere((item) => item.idname == 'rectangle_corenode');
        }

        // TODO
        outputNode.setConnection('layer', inNode, 'output');
        //print(outputNode.connectedNode);
        //print(firstLayerNodes);

        Renderer renderer = Renderer(nodes: layerNodes);
        CanvasItem result = renderer.render('output_corenode');
        result.opacity = (layer.opacity * 2.55).toInt();
        print(result.opacity);
        finalResult.add(result);
      }
    }
    _result = finalResult;
    notifyListeners();
  }
}
