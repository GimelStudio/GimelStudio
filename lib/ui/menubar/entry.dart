// Code in this file is from https://github.com/iakdis/menu_bar licensed as follows:
//
// Copyright 2023 iakmds <andreas(at)iakmds(dot)com>
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice, this
// list of conditions and the following disclaimer in the documentation and/or other
// materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its contributors may
// be used to endorse or promote products derived from this software without specific
// prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
// SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
// TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
// ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter/material.dart';

import 'submenu.dart';

enum MenuEntryType {
  barButton,
  menuButton,
  menuDivider,
}

class MenuEntry {
  const MenuEntry({
    required this.text,
    required this.menuEntryType,
    this.icon,
    this.shortcut,
    this.shortcutText,
    this.shortcutStyle,
    this.onTap,
    this.submenu,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
  }) : assert(submenu == null || onTap == null, 'onTap is ignored if submenu is provided');
  final MenuEntryType menuEntryType;
  final Widget? text;
  final Widget? icon;
  final MenuSerializableShortcut? shortcut;
  final String? shortcutText;
  final TextStyle? shortcutStyle;
  final VoidCallback? onTap;
  final SubMenu? submenu;
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  static List<Widget> build({
    required List<MenuEntry> entries,
    required ButtonStyle barButtonStyle,
    required ButtonStyle menuButtonStyle,
  }) {
    Widget buildSelection(MenuEntry entries) {
      if (entries.menuEntryType == MenuEntryType.menuDivider) {
        return Divider(
          height: entries.height,
          thickness: entries.thickness,
          indent: entries.indent,
          endIndent: entries.endIndent,
          color: entries.color,
        );
      }

      if (entries.submenu != null) {
        return SubmenuButton(
          style: entries.menuEntryType == MenuEntryType.barButton ? barButtonStyle : menuButtonStyle,
          leadingIcon: entries.icon,
          menuChildren: MenuEntry.build(
            entries: entries.submenu!.menuItems,
            barButtonStyle: barButtonStyle,
            menuButtonStyle: menuButtonStyle,
          ),
          child: entries.text,
        );
      }
      return MenuItemButton(
        style: menuButtonStyle,
        leadingIcon: entries.icon,
        trailingIcon: entries.shortcutText != null ? Text(entries.shortcutText!, style: entries.shortcutStyle) : null,
        onPressed: entries.onTap,
        child: entries.text,
      );
    }

    return entries.map<Widget>(buildSelection).toList();
  }

  static Map<MenuSerializableShortcut, Intent> shortcuts(List<MenuEntry> selections) {
    final Map<MenuSerializableShortcut, Intent> result = <MenuSerializableShortcut, Intent>{};
    for (final MenuEntry selection in selections) {
      if (selection.submenu != null) {
        result.addAll(MenuEntry.shortcuts(selection.submenu!.menuItems));
      } else {
        if (selection.shortcut != null && selection.onTap != null) {
          result[selection.shortcut!] = VoidCallbackIntent(selection.onTap!);
        }
      }
    }
    return result;
  }
}
