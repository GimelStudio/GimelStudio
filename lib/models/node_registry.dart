import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/nodes.dart';

Map<String, NodeBase> nodeRegistry = {
  'integer': NodeBase(name: 'integer'),
  'add': AddNode(name: 'add'),
  'output': OutputNode(name: 'output'),
};
