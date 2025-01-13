import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:stacked/stacked.dart';

class TopBarMenubarModel extends BaseViewModel {
  final _documentsService = locator<DocumentService>();

  ShortcutRegistryEntry? shortcutsEntry;

  void onNew() {}

  void onOpen() {}

  void onClose() {}

  void onCloseAll() {}

  void onSave() {}

  void onSaveAs() {}

  void onExport() {}

  void onExit() {}

  void onPreferences() {}

  void onAbout() {}

  // Internal method
  void onDispose() {
    shortcutsEntry?.dispose();
  }
}
