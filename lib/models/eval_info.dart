import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';

class EvalInfo {
  EvalInfo({required this.node});

  final NodeBase node;

  /// Evaluate the value of the parameter [name] of [node].
  dynamic evaluateProperty(String name) {
    Property prop = node.properties[name]!;
    if (prop.connection != null) {
      // Evaluate the next node
      EvalInfo info = EvalInfo(node: prop.connection!.$1);
      return prop.connection?.$1.evaluateNode(info)[prop.connection!.$2];
    }
    return prop.value;
  }
}
