import 'dart:convert';
import 'dart:ui';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/services/file_service.dart';
import 'package:gimelstudio/services/id_service.dart';
import 'package:gimelstudio/services/open_file_service.dart';
import 'package:stacked/stacked.dart';

/// Top-level interface for interacting with documents.
class DocumentService with ListenableServiceMixin {
  final _idsService = locator<IdService>();
  final _fileService = locator<FileService>();
  final _openFileService = locator<OpenFileService>();

  DocumentService() {
    listenToReactiveValues([
      activeDocument,
      _activeDocumentIndex,
      _documents,
    ]);
  }

  /// The current, active document in the interface.
  int _activeDocumentIndex = 0;
  int get selectedDocumentIndex => _activeDocumentIndex;
  Document? get activeDocument => _documents.isEmpty ? null : _documents[_activeDocumentIndex];

  /// Documents that are currently open.
  final List<Document> _documents = [];
  List<Document> get documents => _documents;

  /// Set [selectedDocument] as the current tab in the interface.
  void setSelectedDocumentTab(Document selectedDocument) {
    _activeDocumentIndex = _documents.indexOf(selectedDocument);
    notifyListeners();
  }

  /// Reorder document tabs.
  void reorderDocumentTabs(int oldIndex, int newIndex, {flutterWorkaround = true}) {
    if (flutterWorkaround == true) {
      if (oldIndex < newIndex) {
        // This is necessary because of a bug
        // in the Flutter widget.
        newIndex -= 1;
      }
    }

    final Document item = _documents.removeAt(oldIndex);
    _activeDocumentIndex = newIndex;
    _documents.insert(newIndex, item);

    notifyListeners();
  }

  /// Create a blank document with the given [name] and [size].
  Document createNewDocument(String name, Size size) {
    Document newDocument = Document(
      id: _idsService.newId(),
      name: name,
      size: size,
      layers: [],
      selectedLayers: [],
    );
    _documents.add(newDocument);
    notifyListeners();
    return newDocument;
  }

  /// Opens a file dialog to choose a file to open as a document.
  Future<Document?> openDocument() async {
    String? filePath = await _fileService.selectFile();
    if (filePath == null) {
      return null;
    }

    return await openDocumentFromPath(filePath);
  }

  /// Open a file at [path] as a document.
  Future<Document?> openDocumentFromPath(String path) async {
    Document? openedDocument = await _openFileService.openFilePathAsDocument(path);
    if (openedDocument == null) {
      return null;
    }
    _documents.add(openedDocument);
    notifyListeners();
    setSelectedDocumentTab(openedDocument);
    return openedDocument;
  }

  /// Immediately close [document] in the interface.
  /// This method does not handle saving the document.
  void closeDocument(Document document) {
    _documents.remove(document);
    // TODO: set _selectedDocumentIndex similarily to how removing a layer works.
    _activeDocumentIndex = 0;
    notifyListeners();
  }

  /// Save [document] to a file.
  Future<void> saveDocument(Document document) async {
    if (activeDocument != null) {
      await saveDocumentToFile(activeDocument!);
    }
    notifyListeners();
  }

  Future<void> saveDocumentToFile(Document document) async {
    // Note for the future: currently, there is a 1:1 saving of each model's data.
    // For debugging purposes, saving all of the model data is helpful.
    // However, in the future we should only save the fields that make sense,
    // for both file size and backwards-compatibility reasons.
    Map<String, dynamic> data = {
      'metadata': {
        'version': 0.1,
      },
      'contents': document.toJson(),
    };

    await _fileService.saveFile(jsonEncode(data));
    document.isSaved = true;
    notifyListeners();
  }

  void renameDocument(Document document, String newName) {
    // TODO
    notifyListeners();
  }

  void setEvaluationResult(List<CanvasItem> result) {
    activeDocument?.result = result;
    notifyListeners();
  }
}
