import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'node_socket_widget_model.dart';

class NodeSocketWidget extends StackedView<NodeSocketWidgetModel> {
  const NodeSocketWidget({
    super.key,
    required this.type,
    required this.isOutput,
  });

  final Type type;
  final bool isOutput;

  @override
  Widget builder(
    BuildContext context,
    NodeSocketWidgetModel viewModel,
    Widget? child,
  ) {
    return Container(
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
        color: Color(0xFFCBCE17),
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: Color(0xFF1F1F1F)),
      ),
    );
  }

  @override
  NodeSocketWidgetModel viewModelBuilder(
    BuildContext context,
  ) =>
      NodeSocketWidgetModel();
}
