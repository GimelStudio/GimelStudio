import 'package:flutter/material.dart';
import 'package:gimelstudio/ui/widgets/top_bar/top_bar_model.dart';
import 'package:gimelstudio/ui/widgets/top_bar/widgets/document_tabs/document_tabs.dart';
import 'package:gimelstudio/ui/widgets/top_bar/widgets/top_bar_menubar/top_bar_menubar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

class TopBar extends StackedView<TopBarModel> {
  const TopBar({super.key});

  @override
  Widget builder(
    BuildContext context,
    TopBarModel viewModel,
    Widget? child,
  ) {
    return Container(
      height: 36.0,
      color: Color(0xFF1C1C1C),
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        children: [
          Image.asset(
            'assets/gimel-studio-icon.png',
            width: 16.0,
            height: 16.0,
            isAntiAlias: true,
            cacheHeight: 70,
            cacheWidth: 70,
            filterQuality: FilterQuality.medium,
          ),
          const SizedBox(width: 2.0),
          InkWell(
            onTap: () => viewModel.onToggleShowMenu(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: PhosphorIcon(
                viewModel.showMenu == true
                    ? PhosphorIcons.caretLeft(PhosphorIconsStyle.bold)
                    : PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
                color: const Color.fromARGB(134, 255, 255, 255),
                size: 8.0,
              ),
            ),
          ),
          const SizedBox(width: 2.0),
          viewModel.showMenu == true ? const TopBarMenubar() : const SizedBox(),
          viewModel.showMenu == true ? const SizedBox(width: 20.0) : const SizedBox(),
          const DocumentTabs(),
        ],
      ),
    );
  }

  @override
  TopBarModel viewModelBuilder(
    BuildContext context,
  ) =>
      TopBarModel();
}
