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

import 'entry.dart';
import 'submenu.dart';

class BarButton extends MenuEntry {
  /// A [BarButton] is displayed as a button in the bar.
  ///
  /// The following 2 fields are necessary: [text] and [submenu].
  ///
  /// Assign a widget to the [text] field. This text is displayed as the button text, for example "File", "Edit", "Help", etc.
  ///
  /// Assign a SubMenu to the [submenu] field. This submenu is the menu that is opened on when tapping this button.
  ///
  /// You can style the [BarButton] widgets in the `barButtonStyle` field of your MenuBarWidget.
  const BarButton({
    required Widget text,
    required SubMenu submenu,
  }) : super(
          menuEntryType: MenuEntryType.barButton,
          text: text,
          submenu: submenu,
        );
}

class MenuButton extends MenuEntry {
  /// A [MenuButton] is displayed as a button in the menus and submenus.
  ///
  /// The following field is necessary: [text].
  ///
  /// Assign a Text widget to the [text] field. This text is displayed as the button text. You can also wrap your assigned Text around a Padding widget.
  ///
  /// **Optional fields**
  ///
  /// To open a submenu on press, assign a SubMenu widget to the [submenu] field. **IMPORTANT**: The [onTap] field has to be `null` if [submenu] is set.
  ///
  /// To display a leading icon, assign an Icon widget to the [icon] field.
  ///
  /// To trigger the [onTap] with a keyboard shortcut, assign a `MenuSerializableShortcut` to the [shortcut] field. For example: `SingleActivator(LogicalKeyboardKey.keyS, control: true)`
  ///
  /// To display a trailing shortcut text, assign a String to the [shortcutText] field. You can style this text in the `shortcutTextStyle` field.
  ///
  /// You can style the [MenuButton] widgets in the `menuButtonStyle` field of your MenuBarWidget.
  const MenuButton({
    required Widget text,
    super.onTap,
    super.submenu,
    super.icon,
    super.shortcut,
    super.shortcutText,
    TextStyle shortcutStyle = const TextStyle(fontWeight: FontWeight.w400, color: Colors.white54, fontSize: 13.0),
  }) : super(menuEntryType: MenuEntryType.menuButton, text: text, shortcutStyle: shortcutStyle);
}
