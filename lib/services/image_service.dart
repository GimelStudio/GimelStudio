import 'package:stacked/stacked.dart';

class ImageService with ListenableServiceMixin {
  ImageService() {
    listenToReactiveValues([]);
  }

  String _imagePath = '';
  String get imagePath => _imagePath;

  void setImagePath(String path) {
    _imagePath = path;
    notifyListeners();
  }
}
