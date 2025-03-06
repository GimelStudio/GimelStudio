import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:stacked/stacked.dart';

class NewDocumentDialogModel extends BaseViewModel {
  final _documentsService = locator<DocumentService>();
  final _evaluationService = locator<EvaluationService>();

  double _documentWidth = 1920.0;
  double _documentHeight = 1080.0;
  double get documentWidth => _documentWidth;
  double get documentHeight => _documentHeight;

  Future<bool> onOpenFile() async {
    Document? document = await _documentsService.openDocument();
    if (document == null) {
      return false;
    }
    _evaluationService.evaluate();
    return true;
  }

  void onDocumentWidthChange(double width) {
    _documentWidth = width;
    rebuildUi();
  }

  void onDocumentHeightChange(double height) {
    _documentHeight = height;
    rebuildUi();
  }

  Document onCreateNewDocument() {
    return _documentsService.createNewDocument('Untitled', Size(documentWidth, documentHeight));
  }
}
