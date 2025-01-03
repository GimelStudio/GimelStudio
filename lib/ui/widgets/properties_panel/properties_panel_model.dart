import 'dart:typed_data';

import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/services/image_service.dart';
import 'package:opencv_core/opencv.dart' as cv;
import 'package:stacked/stacked.dart';

class PropertiesPanelModel extends BaseViewModel {
  final _imageService = locator<ImageService>();

  cv.Mat? get imageMat => _imageService.imageMat;

  Uint8List? get image => _imageFile;
  Uint8List? _imageFile;

  double _value = 3.0;
  double get value => _value;

  void setValue(double value) {
    _value = value;
    rebuildUi();
  }

  Future<void> updateBlur(int x, int y) async {
    if (imageMat != null) {
      cv.Mat mat = await _imageService.blurImage(imageMat!, x, y);

      _imageFile = _imageService.imageMatToUint8List(mat);
    }
    rebuildUi();
  }
}
