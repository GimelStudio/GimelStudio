import 'dart:convert';
import 'dart:ui';

import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/services/file_service.dart';
import 'package:gimelstudio/services/id_service.dart';
import 'package:stacked/stacked.dart';

class DocumentService with ListenableServiceMixin {
  final _idsService = locator<IdService>();
  final _fileService = locator<FileService>();

  DocumentService() {
    listenToReactiveValues([
      selectedDocument,
      _selectedDocumentIndex,
      _documents,
    ]);
  }

  /// The current, active document in the interface.
  Document? get selectedDocument => _documents.isEmpty ? null : _documents[_selectedDocumentIndex];

  int _selectedDocumentIndex = 0;
  int get selectedDocumentIndex => _selectedDocumentIndex;

  /// Documents that are currently open.
  final List<Document> _documents = [];
  List<Document> get documents => _documents;

  void setSelectedDocumentTab(Document selectedDocument) {
    _selectedDocumentIndex = _documents.indexOf(selectedDocument);
    notifyListeners();
  }

  void reorderDocumentTabs(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      // This is necessary because of a bug
      // in the Flutter widget.
      newIndex -= 1;
    }
    final Document item = _documents.removeAt(oldIndex);
    _selectedDocumentIndex = newIndex;
    _documents.insert(newIndex, item);

    notifyListeners();
  }

  void createNewDocument(String name, Size size) {
    Document newDocument = Document(
      id: _idsService.newId(),
      name: name,
      size: size,
      layers: [],
    );
    _documents.add(newDocument);
    notifyListeners();
  }

  void openExistingDocument() {
    // TODO: open the file, read the contents and such...
    // Document openedDocument = ...
    //_documents.add(openedDocument);
    notifyListeners();
  }

  void closeDocument(Document document) {
    _documents.remove(document);
    // TODO: set _selectedDocumentIndex similarily to how removing a layer works.
    _selectedDocumentIndex = 0;
    notifyListeners();
  }

  Future<void> saveDocument(Document document) async {
    if (selectedDocument != null) {
      await saveDocumentToFile(selectedDocument!);
    }
    notifyListeners();
  }

  Future<void> saveDocumentToFile(Document document) async {
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
    notifyListeners();
  }
}
