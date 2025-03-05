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
                    isSelected: viewModel.activeTool == Tool.cursor,
                    isDisabled: false,
                    normalIcon: PhosphorIcons.cursor(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.cursor(PhosphorIconsStyle.fill),
                    tooltipText: 'Move Tool',
                    //tooltipKeyboardShortcut: 'V',
                    onTap: () => viewModel.onSelectTool(Tool.cursor),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.activeTool == Tool.hand,
                    isDisabled: false,
                    normalIcon: PhosphorIcons.hand(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.hand(PhosphorIconsStyle.fill),
                    tooltipText: 'Hand Tool',
                    onTap: () => viewModel.onSelectTool(Tool.hand),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.activeTool == Tool.node,
                    isDisabled: true,
                    normalIcon: PhosphorIcons.navigationArrow(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.navigationArrow(PhosphorIconsStyle.fill),
                    tooltipText: 'Node Tool',
                    onTap: () => viewModel.onSelectTool(Tool.node),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.activeTool == Tool.rectangle,
                    isDisabled: false,
                    normalIcon: PhosphorIcons.rectangle(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.rectangle(PhosphorIconsStyle.fill),
                    tooltipText: 'Rectangle Tool',
                    //tooltipKeyboardShortcut: 'R',
                    onTap: () => viewModel.onSelectTool(Tool.rectangle),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.activeTool == Tool.circle, // TODO: rename to oval
                    isDisabled: true,
                    normalIcon: PhosphorIcons.circle(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.circle(PhosphorIconsStyle.fill),
                    tooltipText: 'Oval Tool',
                    onTap: () => viewModel.onSelectTool(Tool.circle),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.activeTool == Tool.triangle,
                    isDisabled: true,
                    normalIcon: PhosphorIcons.triangle(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.triangle(PhosphorIconsStyle.fill),
                    tooltipText: 'Triangle Tool',
                    onTap: () => viewModel.onSelectTool(Tool.triangle),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.activeTool == Tool.polygon,
                    isDisabled: true,
                    normalIcon: PhosphorIcons.pentagon(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.pentagon(PhosphorIconsStyle.fill),
                    tooltipText: 'Polygon Tool',
                    onTap: () => viewModel.onSelectTool(Tool.polygon),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.activeTool == Tool.text,
                    isDisabled: true,
                    normalIcon: PhosphorIcons.textT(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.textT(PhosphorIconsStyle.fill),
                    tooltipText: 'Text Tool',
                    onTap: () => viewModel.onSelectTool(Tool.text),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.activeTool == Tool.image,
                    isDisabled: false,
                    normalIcon: PhosphorIcons.imageSquare(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.imageSquare(PhosphorIconsStyle.fill),
                    tooltipText: 'Image Tool',
                    //tooltipKeyboardShortcut: 'M',
                    onTap: () => viewModel.onSelectTool(Tool.image),
                  ),
                  ToolBarBtn(
                    isSelected: viewModel.activeTool == Tool.eyedropper,
                    isDisabled: true,
                    normalIcon: PhosphorIcons.eyedropper(PhosphorIconsStyle.light),
                    selectedIcon: PhosphorIcons.eyedropper(PhosphorIconsStyle.fill),
                    tooltipText: 'Eyedropper Tool',
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
