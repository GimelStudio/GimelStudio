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

  /// Implementation ideas "in theory"
  ///
  /// Progressive image processing
  /// In order to not lock up the rest of the interface when doing heavy image editing,
  /// Image layers are treated differently from other canvas item layers.
  ///
  /// When the evaluation loop finds a layer with the image canvas image that has
  /// 1) Outdated cache and 2) Needs image processing it adds it to the queue*
  /// for further processing.
  ///
  /// The progressive image processing is generally for heavy image editing and should
  /// be avoided for small operations since it is likely overkill for anything that
  /// renders in less than 1sec.
  ///
  /// *This queue is separate from the main evaluation and works like Dart async,
  /// "coming back" to evaluate the image after all the layers and the placeholder image**
  /// is displayed to the canvas.
  /// If there are many events happening in close sequence, (in addition to
  /// debouncing) the time to render is averaged and that determines the quality
  /// at which the next render of image is processed until there is an idle point
  /// at which to render the full-quality image.
  /// Side note: this might be useful as a setting because some users do not care
  /// to wait and see the full-res image each time.
  ///
  /// **In the meantime, a lower quality image (think: progressive enhancement)
  /// to show that processing is taking place is displayed in the UI. Perhaps there could also
  /// be a spinner or loading progress bar.
  ///
  /// Layer caching:
  /// Each layer has lastCache and needsEvaluation parameters.
  /// 1. The last evaluation for the layer is saved to the cache (lastCache).
  /// 2. When a node in the layer is edited needsEvaluation is marked true.
  /// 3. The layer is evaluated, the cache is updated, and needsEvaluation is marked false.
  /// On a normal evaluation (i.e: a document wasn't just opened which would require a full evaluation),
  /// the evaluator will just use the cache from layers marked needsEvaluation=false.
  ///
  ///
  /// Node caching:
  /// The evaluator only needs to re-evaluate the node properties that have changed. This
  /// could work in a similar fashion to the layer caching.

  void evaluate() {
    List<CanvasItem> finalResult = [];
    if (layers.isNotEmpty) {
      // Sort layers and exclude hidden
      // TODO: hidden layers should probably be disregarded during drawing to the canvas
      // rather than removed before evaluation.
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
