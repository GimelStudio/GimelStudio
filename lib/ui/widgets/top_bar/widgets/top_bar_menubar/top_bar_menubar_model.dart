import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimelstudio/app/app.dialogs.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:gimelstudio/services/export_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TopBarMenubarModel extends BaseViewModel {
  final _documentsService = locator<DocumentService>();
  final _exportService = locator<ExportService>();
  final _evaluationService = locator<EvaluationService>();
  final _dialogService = locator<DialogService>();

  List<Document> get documents => _documentsService.documents;
  Document? get activeDocument => _documentsService.activeDocument;

  List<CanvasItem>? get items => activeDocument?.result;

  ShortcutRegistryEntry? shortcutsEntry;

  /// Menu item and keybinding event to create a new document in a tab.
  Future<void> onNew() async {
    DialogResponse? response = await _dialogService.showCustomDialog(
      variant: DialogType.newDocument,
      data: true,
    );

    if (response?.confirmed == true) {
      _documentsService.setSelectedDocumentTab(response?.data);
    }
  }

  /// Menu item and keybinding event to open a document or image file.
  Future<void> onOpen() async {
    Document? document = await _documentsService.openDocument();
    if (document == null) return;
    _evaluationService.evaluate();
  }

  /// Menu item and keybinding event to close the current document tab.
  void onClose() {
    if (activeDocument == null) {
      return;
    }
    _documentsService.closeDocument(activeDocument!);
  }

  /// Menu item and keybinding event to close all open document tabs.
  void onCloseAll() {
    for (Document document in documents) {
      _documentsService.closeDocument(document);
    }
  }

  /// Menu item and keybinding event to save the current document.
  ///
  /// If the document isn't saved to file yet, this does the save as [onSave].
  void onSave() {}

  /// Menu item and keybinding event to save the current document as a new file.
  void onSaveAs() {}

  /// Menu item and keybinding event to export to an image.
  Future<void> onExport() async {
    if (activeDocument != null && items != null) {
      _evaluationService.evaluate();
      await _exportService.export(items!, activeDocument!.size);
    }
  }

  /// Menu item and keybinding event to quit the application.
  Future<void> onExit() async {
    // https://github.com/flutter/flutter/issues/106360
    // if (document != null) {}
    // if (document.isSaved == false){
    // TODO: should ask whether the user wants to save their work.
    // } else {
    await SystemNavigator.pop();
    // }
  }

  /// Menu item and keybinding event to open the preferences dialog.
  Future<void> onPreferences() async {
    await _dialogService.showCustomDialog(
      variant: DialogType.preferences,
    );
  }

  /// Menu item and keybinding event to open the about dialog.
  Future<void> onAbout() async {
    await _dialogService.showCustomDialog(
      variant: DialogType.about,
    );
  }

  // Internal method
  void onDispose() {
    shortcutsEntry?.dispose();
  }
}
