import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'top_bar_menu_btn_model.dart';

class TopBarMenuBtn extends StackedView<TopBarMenuBtnModel> {
  const TopBarMenuBtn({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget builder(
    BuildContext context,
    TopBarMenuBtnModel viewModel,
    Widget? child,
  ) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white60,
        fontSize: 14.0,
      ),
    );
  }

  @override
  TopBarMenuBtnModel viewModelBuilder(
    BuildContext context,
  ) =>
      TopBarMenuBtnModel();
}
