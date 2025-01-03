import 'package:flutter/material.dart';
import 'package:gimelstudio/ui/widgets/menu_bar/top_menu_bar_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

class TopMenuBar extends StackedView<TopMenuBarModel> {
  const TopMenuBar({super.key});

  @override
  Widget builder(
    BuildContext context,
    TopMenuBarModel viewModel,
    Widget? child,
  ) {
    return Container(
      height: 36.0,
      color: Color(0xFF1C1C1C),
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        children: [
          Image.asset(
            'assets/Icon.png',
            width: 16.0,
            height: 16.0,
            isAntiAlias: true,
            cacheHeight: 100,
            cacheWidth: 100,
            filterQuality: FilterQuality.high,
          ),
          const SizedBox(width: 6.0),
          PhosphorIcon(
            PhosphorIcons.caretLeft(PhosphorIconsStyle.bold),
            color: const Color.fromARGB(134, 255, 255, 255),
            size: 8.0,
          ),
          const SizedBox(width: 18.0),
        ],
      ),
    );
  }

  @override
  TopMenuBarModel viewModelBuilder(
    BuildContext context,
  ) =>
      TopMenuBarModel();
}
