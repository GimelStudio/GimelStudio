import 'package:flutter/material.dart';
import 'package:gimelstudio/ui/widgets/top_bar/widgets/top_bar_menu_btn/top_bar_menu_btn.dart';
import 'package:stacked/stacked.dart';

import 'top_bar_menubar_model.dart';

class TopBarMenubar extends StackedView<TopBarMenubarModel> {
  const TopBarMenubar({super.key});

  @override
  Widget builder(
    BuildContext context,
    TopBarMenubarModel viewModel,
    Widget? child,
  ) {
    return Row(
      spacing: 14.0,
      children: [
        TopBarMenuBtn(label: 'File'),
        TopBarMenuBtn(label: 'Edit'),
        TopBarMenuBtn(label: 'View'),
        TopBarMenuBtn(label: 'Help'),
      ],
    );
  }

  @override
  TopBarMenubarModel viewModelBuilder(
    BuildContext context,
  ) =>
      TopBarMenubarModel();
}
