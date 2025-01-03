import 'package:flutter/material.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/ui/widgets/node_graph_panel/node_graph_panel_model.dart';
import 'package:gimelstudio/ui/widgets/node_graph_panel/widgets/node_widget/node_widget.dart';
import 'package:stacked/stacked.dart';

import '../../../models/node_registry.dart';

class NodeGraphPanel extends StackedView<NodeGraphPanelModel> {
  const NodeGraphPanel({super.key});

  @override
  Widget builder(
    BuildContext context,
    NodeGraphPanelModel viewModel,
    Widget? child,
  ) {
    return Stack(
      children: [
        Container(color: Color(0xFF262626)),
        ...viewModel.nodes.entries.map(
          (MapEntry<String, NodeBase> key) {
            NodeBase? definition = nodeRegistry[key.value.name];
            if (definition != null) {
              return NodeWidget(
                node: key.value,
                onTapNode: () => viewModel.onSelectNode(key),
                onNodeMoved: (newPosition) => viewModel.onNodeMoved(key, newPosition),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );

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
