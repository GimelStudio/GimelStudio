import 'dart:typed_data';

import 'package:opencv_core/opencv.dart' as cv;
import 'package:stacked/stacked.dart';

class ImageService with ListenableServiceMixin {
  ImageService() {
    listenToReactiveValues([
      _imageMat,
    ]);
  }

  String _imagePath = '';
  String get imagePath => _imagePath;

  cv.Mat? _imageMat;
  cv.Mat? get imageMat => _imageMat;

  void loadImageMatFromPath(String path) {
    final cv.Mat mat = cv.imread(path);
    setImageMat(mat);
    setImagePath(path);
  }

  void setImageMat(cv.Mat mat) {
    _imageMat = mat;
    notifyListeners();
  }

  void setImagePath(String path) {
    _imagePath = path;
    notifyListeners();
  }

  Uint8List? imageMatToUint8List(cv.Mat? mat) {
    if (mat == null) {
      return null;
    }
    return cv.imencode('.jpg', mat).$2;
  }

  Future<cv.Mat> blurImage(cv.Mat im, int x, int y) async {
    final blur = await cv.gaussianBlurAsync(im, (19, 19), x.toDouble(), sigmaY: y.toDouble());
    //blur.dispose();
    return blur;
  }
}
