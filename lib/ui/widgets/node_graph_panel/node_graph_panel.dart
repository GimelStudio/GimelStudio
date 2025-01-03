import 'package:flutter/material.dart';
import 'package:gimelstudio/ui/widgets/node_graph_panel/node_graph_panel_model.dart';
import 'package:stacked/stacked.dart';

class NodeGraphPanel extends StackedView<NodeGraphPanelModel> {
  const NodeGraphPanel({super.key});

  @override
  Widget builder(
    BuildContext context,
    NodeGraphPanelModel viewModel,
    Widget? child,
  ) {
    return Container(
      height: 100,
      color: Color(0xFF262626),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [],
      ),
    );
  }

  @override
  NodeGraphPanelModel viewModelBuilder(
    BuildContext context,
  ) =>
      NodeGraphPanelModel();
}
