import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.bottomsheets.dart';
import 'package:gimelstudio/app/app.dialogs.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MainViewModel extends ReactiveViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _documentsService = locator<DocumentService>();

  List<Document> get documents => _documentsService.documents;

  Future<void> showStartupDialog() async {
    await _dialogService.showCustomDialog(
      variant: DialogType.newDocument,
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: 'Bottom sheet',
      description: '...',
    );
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_documentsService];
}
