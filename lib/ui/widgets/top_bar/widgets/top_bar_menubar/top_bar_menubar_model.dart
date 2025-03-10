import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimelstudio/app/app.dialogs.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:gimelstudio/services/export_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class TopBarMenubarModel extends BaseViewModel {
  final _documentsService = locator<DocumentService>();
  final _exportService = locator<ExportService>();
  final _evaluationService = locator<EvaluationService>();
  final _dialogService = locator<DialogService>();
  final _layersService = locator<LayersService>();

  List<Document> get documents => _documentsService.documents;
  Document? get activeDocument => _documentsService.activeDocument;

  List<CanvasItem>? get items => activeDocument?.result;

  List<Layer> get layers => _layersService.layers;
  List<Layer> get selectedLayers => _layersService.selectedLayers;

  ShortcutRegistryEntry? shortcutsEntry;

  /// FILE

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
  Future<void> onCloseAll() async {
    List<Document> documentsToClose = List.of(documents);
    for (Document document in documentsToClose) {
      _documentsService.closeDocument(document);
    }

    await _dialogService.showCustomDialog(
      variant: DialogType.newDocument,
      data: false,
    );
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
      await _exportService.export(activeDocument!.background, items!, activeDocument!.size);
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

  /// EDIT

  /// Menu item to open the preferences dialog.
  Future<void> onPreferences() async {
    await _dialogService.showCustomDialog(
      variant: DialogType.preferences,
    );
  }

  /// LAYER

  /// Menu item and keybinding event to lock the currently selected layers, if any.
  void onLock() {
    _layersService.setLayersLocked(selectedLayers);
    _evaluationService.evaluate();
  }

  /// Menu item and keybinding event to unlock the currently selected layers, if any.
  void onUnlock() {
    _layersService.setLayersUnlocked(selectedLayers);
    _evaluationService.evaluate();
  }

  /// Menu item and keybinding event to unlock all layers, if any.
  void onUnlockAll() {
    _layersService.setLayersUnlocked(layers);
    _evaluationService.evaluate();
  }

  /// Menu item and keybinding event to hide the currently selected layers, if any.
  void onHide() {
    _layersService.setLayersHidden(selectedLayers);
    _evaluationService.evaluate();
  }

  /// Menu item and keybinding event to show the currently selected layers, if any.
  void onShow() {
    _layersService.setLayersVisible(selectedLayers);
    _evaluationService.evaluate();
  }

  /// Menu item and keybinding event to show all layers, if any.
  void onShowAll() {
    _layersService.setLayersVisible(layers);
    _evaluationService.evaluate();
  }

  /// Menu item and keybinding event to delete the currently selected layers, if any.
  void onDelete() {
    _layersService.deleteLayers(selectedLayers);
    _evaluationService.evaluate();
  }

  /// HELP

  /// Menu item to launch the Gimel Studio website in a browser.
  Future<void> onVisitWebsite() async {
    await launchUrl(Uri.https('gimelstudio.com'));
  }

  /// Menu item to launch the Gimel Studio community chat in a browser.
  Future<void> onCommunityChat() async {
    await launchUrl(Uri.https('gimelstudio.zulipchat.com', '/join/sif32f3gjpnikveonzgc7zhw/'));
  }

  /// Menu item to launch the Gimel Studio GitHub repository in a browser.
  Future<void> onGitHubRepository() async {
    await launchUrl(Uri.https('github.com', '/GimelStudio/GimelStudio'));
  }

  /// Menu item to launch the GitHub repository to report a bug.
  Future<void> onReportABug() async {
    await launchUrl(Uri.https('github.com', '/GimelStudio/GimelStudio/issues/new/choose'));
  }

  /// Menu item to open the about dialog.
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
