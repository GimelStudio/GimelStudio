import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_property.dart';

class EvalInfo {
  EvalInfo({required this.node});

  final NodeBase node;

  /// Evaluate the value of the parameter [name] of [node].
  dynamic evaluateProperty(String name) {
    Property prop = node.properties.values.firstWhere((item) => item.idname == name);
    if (prop.connection != null) {
      // Evaluate the next node
      NodeBase connection = prop.connection!.$1;
      String outputIdname = prop.connection!.$2;
      EvalInfo info = EvalInfo(node: connection);
      return connection.evaluateNode(info)[outputIdname];
    }
    return prop.value;
  }
}
