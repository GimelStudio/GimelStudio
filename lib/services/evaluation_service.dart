import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/nodegraph.dart';
import 'package:gimelstudio/models/nodes.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:stacked/stacked.dart';

class EvaluationService extends ReactiveViewModel {
  final _layersService = locator<LayersService>();

  List<Layer> get layers => _layersService.layers;

  int evaluate() {
    return 0;
  }

  void flattenLayersIntoSingleNodegraph() {
    for (Layer layer in layers) {
      NodeGraph nodeGraph = layer.nodegraph;

      for (NodeBase node in nodeGraph.nodes.values) {
        if (node.isOutput == true) {
          NodeBase outputNode = node;
          var t = outputNode.connectedNode?.$1.properties['final'];
          print(t);
        }
      }
    }
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_layersService];
}
