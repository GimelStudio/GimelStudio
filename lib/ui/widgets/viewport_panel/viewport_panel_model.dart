import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:gimelstudio/services/image_service.dart';

import '../../../app/app.locator.dart';
import 'package:stacked/stacked.dart';

class ViewportPanelModel extends ReactiveViewModel {
  final _imageService = locator<ImageService>();
  final _evaluationService = locator<EvaluationService>();

  List<Rectangle>? get result => _evaluationService.result;

  List<Rectangle> get items => result == null ? [] : result ?? [];

  Offset? _draggingStartPosition;
  Offset? get draggingStartPosition => _draggingStartPosition;
  Offset? _draggingInitialNodePosition;
  Offset? get draggingInitialNodePosition => _draggingInitialNodePosition;

  void onPanDown(DragDownDetails event) {
    _draggingStartPosition = event.localPosition;
    _draggingInitialNodePosition = Offset(items[0].x, items[0].y);
    rebuildUi();
  }

  void onPanUpdate(DragUpdateDetails event) {
    var pos = draggingInitialNodePosition! + event.localPosition - draggingStartPosition!;

    items[0].x = pos.dx;
    items[0].y = pos.dy;
    rebuildUi();
  }

  void onPanCancel() {
    //onNodeMoved(draggingInitialNodePosition!);

    _draggingStartPosition = null;
    _draggingInitialNodePosition = null;
    rebuildUi();
  }

  void onPanEnd(DragEndDetails event) {
    _draggingStartPosition = null;
    _draggingInitialNodePosition = null;

    rebuildUi();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_imageService, _evaluationService];
}
