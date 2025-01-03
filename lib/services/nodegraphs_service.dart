import 'package:gimelstudio/models/nodegraph.dart';

class NodegraphsService {
  List<NodeGraph> _nodegraphs = [
    NodeGraph(id: 0),
  ];
  List<NodeGraph> get nodegraphs => _nodegraphs;
}
