import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/services/file_service.dart';
import 'package:gimelstudio/ui/common/enums.dart';
import 'package:gimelstudio/ui/widgets/viewport_panel/viewport_panel.dart';
import 'package:image/image.dart' as img;

class ExportService {
  final _fileService = locator<FileService>();

  Future<bool> export(
    ui.Color canvasBackground,
    List<CanvasItem> canvasItems,
    ui.Size canvasSize,
  ) async {
    String? filePath = await _fileService.getSaveFilePath(suggestedName: 'untitled');

    if (filePath != null) {
      String extension = filePath.split('.').last;
      SupportedFileFormat? exportFormat = _fileService.fileExtensionToFileFormat(extension);

      if (exportFormat == null) {
        // We don't allow "custom" file extensions.
        return false;
      }

      return await exportToImageFormat(filePath, exportFormat, canvasBackground, canvasItems, canvasSize);
    } else {
      return false;
    }
  }

  /// Export the canvas contents to [exportPath] in the given [exportFormat].
  Future<bool> exportToImageFormat(
    String exportPath,
    SupportedFileFormat exportFormat,
    ui.Color canvasBackground,
    List<CanvasItem> canvasItems,
    ui.Size canvasSize,
  ) async {
    bool exportSuccessful = false;

    ui.Image uiImage = await getUiImageFromCanvas(canvasBackground, canvasItems, canvasSize);
    img.Image? image = await convertUiImageToImage(uiImage);

    if (image == null) {
      return exportSuccessful;
    }

    if (exportFormat == SupportedFileFormat.jpg) {
      exportSuccessful = await img.encodeJpgFile(exportPath, image);
    } else if (exportFormat == SupportedFileFormat.png) {
      exportSuccessful = await img.encodePngFile(exportPath, image);
    } else if (exportFormat == SupportedFileFormat.gif) {
      exportSuccessful = await img.encodeGifFile(exportPath, image);
    } else if (exportFormat == SupportedFileFormat.bmp) {
      exportSuccessful = await img.encodeBmpFile(exportPath, image);
    } else if (exportFormat == SupportedFileFormat.tiff) {
      exportSuccessful = await img.encodeTiffFile(exportPath, image);
    } else if (exportFormat == SupportedFileFormat.tga) {
      exportSuccessful = await img.encodeTgaFile(exportPath, image);
    } else if (exportFormat == SupportedFileFormat.ico) {
      exportSuccessful = await img.encodeIcoFile(exportPath, image);
    }
    return exportSuccessful;
  }

  // Utility methods

  /// Records the canvas painting operations and returns a ui.Image.
  ///
  /// This is the first step in exporting the canvas to a raster image.
  Future<ui.Image> getUiImageFromCanvas(
      ui.Color canvasBackground, List<CanvasItem> canvasItems, ui.Size canvasSize) async {
    ui.PictureRecorder recorder = ui.PictureRecorder();

    ui.Canvas canvas = ui.Canvas(recorder);
    ViewportCanvasPainter painter = ViewportCanvasPainter(background: canvasBackground, items: canvasItems);
    painter.paint(canvas, canvasSize);

    ui.Picture picture = recorder.endRecording();
    ui.Image image = await picture.toImage(canvasSize.width.floor(), canvasSize.height.floor());
    picture.dispose();
    return image;
  }

  /// Converts the given ui.Image [uiImage] to an img.Image.
  Future<img.Image?> convertUiImageToImage(ui.Image uiImage) async {
    ByteData? uiBytes = await uiImage.toByteData();

    if (uiBytes == null) {
      // Encoding failed.
      return null;
    }

    img.Image image = img.Image.fromBytes(
        width: uiImage.width, height: uiImage.height, bytes: uiBytes.buffer, numChannels: 4, format: img.Format.uint8);
    return image;
  }
}
