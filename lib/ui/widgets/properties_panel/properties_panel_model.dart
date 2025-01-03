import 'dart:typed_data';

import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/services/image_service.dart';
import 'package:stacked/stacked.dart';

class PropertiesPanelModel extends BaseViewModel {
  final _imageService = locator<ImageService>();

  Uint8List? get image => _imageFile;
  Uint8List? _imageFile;

  double _value = 3.0;
  double get value => _value;

  void setValue(double value) {
    _value = value;
    rebuildUi();
  }
}
