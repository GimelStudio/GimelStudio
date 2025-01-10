import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TopBarMenubarModel extends BaseViewModel {
  ShortcutRegistryEntry? shortcutsEntry;

  void onDispose() {
    shortcutsEntry?.dispose();
  }
}
