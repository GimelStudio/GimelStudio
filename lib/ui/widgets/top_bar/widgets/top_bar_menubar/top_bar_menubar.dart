import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimelstudio/ui/common/app_styles.dart';
import 'package:gimelstudio/ui/menubar/button.dart';
import 'package:gimelstudio/ui/menubar/divider.dart';
import 'package:gimelstudio/ui/menubar/entry.dart';
import 'package:gimelstudio/ui/menubar/submenu.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import 'top_bar_menubar_model.dart';

List<BarButton> _menuBarButtons = [
  BarButton(
    text: Text(
      'File',
      style: AppStyles.menubarItemTextStyle,
    ),
    submenu: SubMenu(
      menuItems: [
        MenuButton(
          onTap: () {},
          text: Text(
            'New…',
            style: AppStyles.menuTextStyle,
          ),
          shortcutText: 'Ctrl+N',
          shortcut: const SingleActivator(LogicalKeyboardKey.keyN, control: true),
        ),
        MenuButton(
          onTap: () {},
          text: Text(
            'Open…',
            style: AppStyles.menuTextStyle,
          ),
          shortcutText: 'Ctrl+O',
          shortcut: const SingleActivator(LogicalKeyboardKey.keyO, control: true),
        ),
        MenuButton(
          onTap: () {},
          text: Text(
            'Close',
            style: AppStyles.menuTextStyle,
          ),
          shortcutText: 'Ctrl+W',
          shortcut: const SingleActivator(LogicalKeyboardKey.keyW, control: true),
        ),
        MenuButton(
          onTap: () {},
          text: Text(
            'Close All',
            style: AppStyles.menuTextStyle,
          ),
          shortcutText: 'Ctrl+Alt+W',
          shortcut: const SingleActivator(LogicalKeyboardKey.keyW, control: true, alt: true),
        ),
        MenuButton(
          onTap: () => print('Save'),
          text: Text(
            'Save',
            style: AppStyles.menuTextStyle,
          ),
          shortcutText: 'Ctrl+S',
          shortcut: const SingleActivator(LogicalKeyboardKey.keyS, control: true),
        ),
        MenuButton(
          onTap: () {},
          text: Text(
            'Save As…',
            style: AppStyles.menuTextStyle,
          ),
          shortcutText: 'Ctrl+Shift+S',
          shortcut: const SingleActivator(LogicalKeyboardKey.keyS, control: true, shift: true),
        ),
        MenuButton(
          onTap: () {},
          text: Text(
            'Export…',
            style: AppStyles.menuTextStyle,
          ),
          shortcutText: 'Ctrl+Alt+Shift+S',
          shortcut: const SingleActivator(LogicalKeyboardKey.keyS, control: true, alt: true, shift: true),
        ),
        MenuButton(
          onTap: () {},
          text: Text(
            'Exit',
            style: AppStyles.menuTextStyle,
          ),
        ),
      ],
    ),
  ),
  BarButton(
    text: Text(
      'Edit',
      style: AppStyles.menubarItemTextStyle,
    ),
    submenu: SubMenu(
      menuItems: [
        MenuButton(
          onTap: () {},
          text: Text(
            'Preferences',
            style: AppStyles.menuTextStyle,
          ),
        ),
      ],
    ),
  ),
  BarButton(
    text: Text(
      'Help',
      style: AppStyles.menubarItemTextStyle,
    ),
    submenu: SubMenu(
      menuItems: [
        MenuButton(
          onTap: () {},
          text: Text(
            'About',
            style: AppStyles.menuTextStyle,
          ),
        ),
      ],
    ),
  ),
];

class TopBarMenubar extends StackedView<TopBarMenubarModel> {
  const TopBarMenubar({super.key});

  @override
  void onDispose(TopBarMenubarModel viewModel) {
    viewModel.onDispose();
    super.onDispose(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    TopBarMenubarModel viewModel,
    Widget? child,
  ) {
    // TODO: this shouldn't be in the build method.
    viewModel.shortcutsEntry?.dispose();
    if (MenuEntry.shortcuts(_menuBarButtons).isNotEmpty) {
      viewModel.shortcutsEntry = ShortcutRegistry.of(context).addAll(MenuEntry.shortcuts(_menuBarButtons));
    }

    return MenuBar(
      style: const MenuStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        surfaceTintColor: WidgetStatePropertyAll(Color(0xFF1C1C1C)),
        backgroundColor: WidgetStatePropertyAll(Color(0xFF1C1C1C)),
        maximumSize: WidgetStatePropertyAll(Size(double.infinity, 36.0)),
        elevation: WidgetStatePropertyAll(0.0),
        side: WidgetStatePropertyAll(BorderSide(width: 0, color: Colors.transparent)),
      ),
      children: MenuEntry.build(
        entries: _menuBarButtons,
        barButtonStyle: const ButtonStyle(
          visualDensity: VisualDensity(horizontal: 0.5, vertical: 2.0),
          textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white60, fontWeight: FontWeight.normal)),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 6.0)),
          minimumSize: WidgetStatePropertyAll(Size(0.0, 32.0)),
          side: WidgetStatePropertyAll(BorderSide(width: 0, color: Colors.transparent)),
        ),
        menuButtonStyle: const ButtonStyle(
          visualDensity: VisualDensity(horizontal: 1.5, vertical: 0.0),
          textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white60, fontWeight: FontWeight.normal)),
          backgroundColor: WidgetStatePropertyAll(Color(0xFF1C1C1C)),
          minimumSize: WidgetStatePropertyAll(Size(200.0, 28.0)),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0)),
          side: WidgetStatePropertyAll(BorderSide(width: 0, color: Colors.transparent)),
        ),
      ),
    );
  }

  @override
  TopBarMenubarModel viewModelBuilder(
    BuildContext context,
  ) =>
      TopBarMenubarModel();
}
