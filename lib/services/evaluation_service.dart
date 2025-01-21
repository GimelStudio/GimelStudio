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

      // TODO: implement layer and node caching
      for (Layer layer in documentLayers) {
        Map<String, Node> layerNodes = layer.nodegraph.nodes;

        //print(outputNode.connectedNode);
        //print(firstLayerNodes);
        Renderer renderer = Renderer(nodes: layerNodes);
        dynamic r = renderer.render('output_corenode');

        //print(r);

        if (r != -1) {
          // -1 means that there is no node connected to the output.
          CanvasItem result = r; // Maybe instead, the layer itself should be returned from each render

          result.opacity = ((layer.opacity * 2.55)).toInt();

          //result.blendMode = layer.blend;
          result.layerId = layer.id;
          finalResult.add(result);
        }
      }
    }
    _result = finalResult;
    notifyListeners();
  }
}
