import 'package:flutter/material.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/ui/widgets/node_graph_panel/node_graph_panel_model.dart';
import 'package:gimelstudio/ui/widgets/node_graph_panel/widgets/node_widget/node_widget.dart';
import 'package:stacked/stacked.dart';

class NodeGraphPanel extends StackedView<NodeGraphPanelModel> {
  const NodeGraphPanel({super.key});

  @override
  Widget builder(
    BuildContext context,
    NodeGraphPanelModel viewModel,
    Widget? child,
  ) {
    return InteractiveViewer(
      maxScale: 4.0,
      minScale: 0.4,
      child: Stack(
        children: [
          Container(color: Color(0xFF262626)),
          ...viewModel.nodes.entries.map(
            (MapEntry<String, Node> key) {
              Node? definition = viewModel.nodeRegistry[key.value.idname];
              if (definition != null) {
                return NodeWidget(
                  node: key.value,
                  onTapNode: () => viewModel.onSelectNode(key.value),
                  onNodeMoved: (newPosition) => viewModel.onNodeMoved(key.value, newPosition),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  NodeGraphPanelModel viewModelBuilder(
    BuildContext context,
  ) =>
      NodeGraphPanelModel();
}
