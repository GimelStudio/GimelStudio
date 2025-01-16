import 'package:gimelstudio/app/app.dialogs.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DocumentTabsModel extends ReactiveViewModel {
  final _documentsService = locator<DocumentService>();
  final _dialogService = locator<DialogService>();

  int get selectedDocumentIndex => _documentsService.selectedDocumentIndex;
  List<Document> get documents => _documentsService.documents;

  void onSelectDocumentTab(Document document) {
    _documentsService.setSelectedDocumentTab(document);
  }

  Future<void> onCloseDocumentTab(Document document) async {
    _documentsService.closeDocument(document);
    if (documents.isEmpty) {
      await _dialogService.showCustomDialog(
        variant: DialogType.startup,
      );
    }
  }

  void onReorderDocumentTabs(int oldIndex, int newIndex) {
    _documentsService.reorderDocumentTabs(oldIndex, newIndex);
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_documentsService];
}
