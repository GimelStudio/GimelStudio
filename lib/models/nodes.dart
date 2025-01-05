import 'package:gimelstudio/models/eval_info.dart';
import 'package:gimelstudio/models/node_base.dart';

class IntegerNode extends NodeBase {
  IntegerNode({
    super.id = '',
    super.idname = 'integer_corenode',
    super.isOutput = false,
    super.label = 'Integer',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  Map<String, int> evaluateNode(EvalInfo eval) {
    int number = eval.evaluateProperty('number');
    return {
      'output': number,
    };
  }
}

class AddNode extends NodeBase {
  AddNode({
    super.id = '',
    super.idname = 'add_corenode',
    super.isOutput = false,
    super.label = 'Add',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  Map<String, int> evaluateNode(EvalInfo eval) {
    int inputA = evaluateProperty(eval, 'a');
    int inputB = evaluateProperty(eval, 'b');

    return {
      'output': inputA + inputB,
    };
  }
}

class OutputNode extends NodeBase {
  OutputNode({
    super.id = '',
    super.idname = 'output_corenode',
    super.isOutput = true,
    super.label = 'Output',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  (NodeBase, String)? get connectedNode {
    return properties['final']?.connection;
  }
}

class OutputNode2 extends NodeBase {
  OutputNode2({
    super.id = '',
    super.idname = 'output2_corenode',
    super.isOutput = true,
    super.label = 'Output2',
    super.selected,
    required super.properties,
    required super.outputs,
    super.position,
  });

  @override
  (NodeBase, String)? get connectedNode {
    return properties['final']?.connection;
  }
}
