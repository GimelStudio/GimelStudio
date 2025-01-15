import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import 'tool_bar_btn_model.dart';

class ToolBarBtn extends StackedView<ToolBarBtnModel> {
  const ToolBarBtn({
    super.key,
    required this.isSelected,
    required this.isDisabled,
    required this.normalIcon,
    required this.selectedIcon,
    required this.onTap,
  });

  final bool isSelected;
  final bool isDisabled;
  final PhosphorIconData normalIcon;
  final PhosphorIconData selectedIcon;
  final Function() onTap;

  @override
  Widget builder(
    BuildContext context,
    ToolBarBtnModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(6.0),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1C1C1C) : Colors.transparent,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: PhosphorIcon(
            isSelected ? selectedIcon : normalIcon,
            color: isSelected ? const Color(0xff5C7AD8) : Colors.white60,
            size: 20.0,
          ),
        ),
      ),
    );
  }

  @override
  ToolBarBtnModel viewModelBuilder(
    BuildContext context,
  ) =>
      ToolBarBtnModel();
}
