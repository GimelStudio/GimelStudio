import 'package:flutter/material.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/node_output.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/ui/widgets/node_graph_panel/widgets/node_socket_widget/node_socket_widget.dart';
import 'package:stacked/stacked.dart';

import 'node_widget_model.dart';

class NodeWidget extends StackedView<NodeWidgetModel> {
  const NodeWidget({
    super.key,
    required this.node,
    required this.onTapNode,
    required this.onNodeMoved,
  });

  final Node node;
  final Function() onTapNode;
  final Function(Offset newPosition) onNodeMoved;

  @override
  Widget builder(
    BuildContext context,
    NodeWidgetModel viewModel,
    Widget? child,
  ) {
    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      child: FractionalTranslation(
        translation: const Offset(-.5, -.5),
        child: MouseRegion(
          cursor: viewModel.draggingStartPosition != null ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
          child: GestureDetector(
            onTapUp: (event) => onTapNode(),
            onPanDown: (event) => viewModel.onPanDown(event, node),
            onPanUpdate: (event) => viewModel.onPanUpdate(event, onNodeMoved),
            onPanCancel: () => viewModel.onPanCancel(onNodeMoved),
            onPanEnd: (event) => viewModel.onPanEnd(event),
            child: Container(
              height: node.size.width,
              width: node.size.height,
              decoration: BoxDecoration(
                color: Color(0xFF333333),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: node.selected ? Colors.white70 : Color(0xFF1F1F1F),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 14.0, right: 14.0),
                    child: Row(
                      spacing: 4.0,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // PhosphorIcon(
                        //   widget.node.icon,
                        //   color: Colors.white70,
                        //   size: 14.0,
                        // ),
                        Expanded(
                          child: Text(
                            node.label,
                            maxLines: 1,
                            style: TextStyle(
                              color: node.selected ? Colors.white : Colors.white70,
                              fontSize: 12.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (Property property in node.properties.values)
                    if (property.isExposed == true)
                      Positioned(
                        top: viewModel.layoutSocketsVertically(
                            node.properties.values.where((item) => item.isExposed == true).toList(), property), // TODO
                        left: -6.0,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: NodeSocketWidget(
                            type: property.dataType,
                            isOutput: false,
                          ),
                        ),
                      ),
                  for (Output output in node.outputs.values)
                    Positioned(
                      top: viewModel.layoutSocketsVertically(node.outputs.values.toList(), output), // TODO
                      left: 124.0,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: NodeSocketWidget(
                          type: output.dataType,
                          isOutput: true,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  NodeWidgetModel viewModelBuilder(
    BuildContext context,
  ) =>
      NodeWidgetModel();
}
