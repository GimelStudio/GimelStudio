import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:stacked/stacked.dart';

class StartupDialogModel extends BaseViewModel {
  final _documentsService = locator<DocumentService>();

  void onCreateNew() {
    _documentsService.createNewDocument('Untitled', Size(1920, 1080));
  }

  void onOpenFile() {
    // TODO: open file and set size according to the image size.
    _documentsService.createNewDocument('Untitled', Size(1920, 1080));
  }
}
