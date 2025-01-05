import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:stacked/stacked.dart';

class DocumentTabsModel extends ReactiveViewModel {
  final _documentsService = locator<DocumentService>();

  int get selectedDocumentIndex => _documentsService.selectedDocumentIndex;
  List<Document> get documents => _documentsService.documents;

  void onSelectDocumentTab(Document document) {
    _documentsService.setSelectedDocumentTab(document);
  }

  void onCloseDocumentTab(Document document) {
    _documentsService.closeDocument(document);
  }

  void onReorderDocumentTabs(int oldIndex, int newIndex) {
    _documentsService.reorderDocumentTabs(oldIndex, newIndex);
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_documentsService];
}
