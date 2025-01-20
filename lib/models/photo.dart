import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';

// TODO: maybe find a better name. This is named "Photo" because
// "Image" is  way too overused in the namespaces.
// Suggestions for another name are welcome.
class Photo {
  Photo({
    required this.filePath,
    required this.data,
  });

  String filePath;
  Uint8List? data;
  ui.Image? uiData;

  Future<ui.Image?> toCanvasImageData() async {
    if (data == null) {
      return null;
    }
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(data!, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }
}
