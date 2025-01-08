import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/services/id_service.dart';
import 'package:stacked/stacked.dart';

class DocumentService with ListenableServiceMixin {
  final _idsService = locator<IdService>();

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

  void saveDocument(Document document) {
    notifyListeners();
  }

  void renameDocument(Document document, String newName) {
    notifyListeners();
  }
}
