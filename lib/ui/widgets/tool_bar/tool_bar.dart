import 'package:flutter/material.dart';
import 'package:gimelstudio/models/tool.dart';
import 'package:gimelstudio/ui/widgets/tool_bar/widgets/tool_bar_btn/tool_bar_btn.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import 'tool_bar_model.dart';

class ToolBar extends StackedView<ToolBarModel> {
  const ToolBar({super.key});

  @override
  Widget builder(
    BuildContext context,
    ToolBarModel viewModel,
    Widget? child,
  ) {
    return Container(
      color: Color(0xFF292929),
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                spacing: 7.0,
                children: [
                  ToolBarBtn(
                    isSelected: viewModel.currentTool == Tool.cursor,
                    normalIcon: PhosphorIcons.cursor(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.cursor(PhosphorIconsStyle.fill),
                    onTap: () => viewModel.onSelectTool(Tool.cursor),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.currentTool == Tool.hand,
                    normalIcon: PhosphorIcons.hand(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.hand(PhosphorIconsStyle.fill),
                    onTap: () => viewModel.onSelectTool(Tool.hand),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.currentTool == Tool.node,
                    normalIcon: PhosphorIcons.navigationArrow(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.navigationArrow(PhosphorIconsStyle.fill),
                    onTap: () => viewModel.onSelectTool(Tool.node),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.currentTool == Tool.rectangle,
                    normalIcon: PhosphorIcons.rectangle(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.rectangle(PhosphorIconsStyle.fill),
                    onTap: () => viewModel.onSelectTool(Tool.rectangle),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.currentTool == Tool.circle,
                    normalIcon: PhosphorIcons.circle(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.circle(PhosphorIconsStyle.fill),
                    onTap: () => viewModel.onSelectTool(Tool.circle),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.currentTool == Tool.triangle,
                    normalIcon: PhosphorIcons.triangle(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.triangle(PhosphorIconsStyle.fill),
                    onTap: () => viewModel.onSelectTool(Tool.triangle),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.currentTool == Tool.polygon,
                    normalIcon: PhosphorIcons.pentagon(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.pentagon(PhosphorIconsStyle.fill),
                    onTap: () => viewModel.onSelectTool(Tool.polygon),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.currentTool == Tool.text,
                    normalIcon: PhosphorIcons.textT(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.textT(PhosphorIconsStyle.fill),
                    onTap: () => viewModel.onSelectTool(Tool.text),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.currentTool == Tool.image,
                    normalIcon: PhosphorIcons.imageSquare(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.imageSquare(PhosphorIconsStyle.fill),
                    onTap: () => viewModel.onSelectTool(Tool.image),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.currentTool == Tool.eyedropper,
                    normalIcon: PhosphorIcons.eyedropper(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.eyedropper(PhosphorIconsStyle.fill),
                    onTap: () => viewModel.onSelectTool(Tool.eyedropper),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  ToolBarModel viewModelBuilder(
    BuildContext context,
  ) =>
      ToolBarModel();
}
