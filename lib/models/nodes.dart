import 'package:gimelstudio/models/eval_info.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_output.dart';
import 'package:gimelstudio/models/node_property.dart';

class IntegerNode extends NodeBase {
  IntegerNode({super.name = 'integer'});

  @override
  void defineMeta() {
    label = 'Integer';
    //icon = PhosphorIcons.numberCircleOne(PhosphorIconsStyle.light);
  }

  @override
  void defineProperties() {
    properties = {
      'number': IntegerProperty(name: 'number', dataType: int, value: 21),
    };
  }

  @override
  void defineOutputs() {
    outputs = {
      'output': Output(
        name: 'output',
        dataType: int,
      ),
    };
  }

  @override
  Map<String, int> evaluateNode(EvalInfo eval) {
    int number = eval.evaluateProperty('number');
    return {
      'output': number,
    };
  }
}

class AddNode extends NodeBase {
  AddNode({super.name = 'add'});

  @override
  void defineMeta() {
    label = 'Add';
    //icon = PhosphorIcons.plusCircle(PhosphorIconsStyle.light);
  }

  @override
  void defineProperties() {
    properties = {
      'a': IntegerProperty(
        name: 'a',
        dataType: int,
        value: 0,
      ),
      'b': IntegerProperty(
        name: 'b',
        dataType: int,
        value: 0,
      ),
    };
  }

  @override
  void defineOutputs() {
    outputs = {
      'output': Output(
        name: 'output',
        dataType: int,
      ),
    };
  }

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
  OutputNode({super.name = 'output'});

  @override
  bool isOutput() {
    return true;
  }

  @override
  (NodeBase, String)? get connectedNode {
    return properties['final']?.connection;
  }

  @override
  void defineMeta() {
    label = 'Output';
    //icon = PhosphorIcons.layout(PhosphorIconsStyle.light);
  }

  @override
  void defineProperties() {
    properties = {
      'final': IntegerProperty(
        name: 'final',
        dataType: int,
        value: 10,
      ),
    };
  }
}

class OutputNode2 extends NodeBase {
  OutputNode2({super.name = 'output2'});

  @override
  bool isOutput() {
    return true;
  }

  @override
  (NodeBase, String)? get connectedNode {
    return properties['final']?.connection;
  }

  @override
  void defineProperties() {
    properties = {
      'final': IntegerProperty(
        name: 'final',
        dataType: int,
        value: 10,
      ),
    };
  }
}
