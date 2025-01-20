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
    List<CanvasItem> canvasItems,
    ui.Size canvasSize,
  ) async {
    String? filePath = await _fileService.getSaveFilePath(suggestedName: 'untitled');

    if (filePath != null) {
      String extension = filePath.split('.').last;
      ExportImageFormat? exportFormat = extensionToExportImageFormat(extension);

      if (exportFormat == null) {
        // We don't allow "custom" file extensions.
        return false;
      }

      return await exportToImageFormat(filePath, exportFormat, canvasItems, canvasSize);
    } else {
      return false;
    }
  }

  /// Export the canvas contents to [exportPath] in the given [exportFormat].
  Future<bool> exportToImageFormat(
    String exportPath,
    ExportImageFormat exportFormat,
    List<CanvasItem> canvasItems,
    ui.Size canvasSize,
  ) async {
    bool exportSuccessful = false;

    ui.Image uiImage = await getUiImageFromCanvas(canvasItems, canvasSize);
    img.Image? image = await convertUiImageToImage(uiImage);

    if (image == null) {
      return exportSuccessful;
    }

    if (exportFormat == ExportImageFormat.jpg) {
      exportSuccessful = await img.encodeJpgFile(exportPath, image);
    } else if (exportFormat == ExportImageFormat.png) {
      exportSuccessful = await img.encodePngFile(exportPath, image);
    } else if (exportFormat == ExportImageFormat.gif) {
      exportSuccessful = await img.encodeGifFile(exportPath, image);
    } else if (exportFormat == ExportImageFormat.bmp) {
      exportSuccessful = await img.encodeBmpFile(exportPath, image);
    } else if (exportFormat == ExportImageFormat.tiff) {
      exportSuccessful = await img.encodeTiffFile(exportPath, image);
    } else if (exportFormat == ExportImageFormat.tga) {
      exportSuccessful = await img.encodeTgaFile(exportPath, image);
    } else if (exportFormat == ExportImageFormat.ico) {
      exportSuccessful = await img.encodeIcoFile(exportPath, image);
    }
    return exportSuccessful;
  }

  // Utility methods

  /// Converts an image extension [imageExtension] to a value of the ExportImageFormat enum.
  ///
  /// null is returned if there is no matching image format in ExportImageFormat.
  /// The parameter [imageExtension] should not include the period.
  ExportImageFormat? extensionToExportImageFormat(String imageExtension) {
    ExportImageFormat? exportFormat;

    switch (imageExtension.toLowerCase()) {
      case 'jpg':
        exportFormat = ExportImageFormat.jpg;
      case 'jpeg':
        exportFormat = ExportImageFormat.jpg;
      case 'png':
        exportFormat = ExportImageFormat.png;
      case 'gif':
        exportFormat = ExportImageFormat.gif;
      case 'bmp':
        exportFormat = ExportImageFormat.bmp;
      case 'tiff':
        exportFormat = ExportImageFormat.tiff;
      case 'tga':
        exportFormat = ExportImageFormat.tga;
      case 'ico':
        exportFormat = ExportImageFormat.ico;
    }
    return exportFormat;
  }

  /// Records the canvas painting operations and returns a ui.Image.
  ///
  /// This is the first step in exporting the canvas to a raster image.
  Future<ui.Image> getUiImageFromCanvas(List<CanvasItem> canvasItems, ui.Size canvasSize) async {
    ui.PictureRecorder recorder = ui.PictureRecorder();

    ui.Canvas canvas = ui.Canvas(recorder);
    ViewportCanvasPainter painter = ViewportCanvasPainter(items: canvasItems);
    painter.paint(canvas, canvasSize);

    ui.Picture picture = recorder.endRecording();
    return await picture.toImage(canvasSize.width.floor(), canvasSize.height.floor());
  }

  /// Converts the given ui.Image [uiImage] to an img.Image.
  Future<img.Image?> convertUiImageToImage(ui.Image uiImage) async {
    ByteData? uiBytes = await uiImage.toByteData();

    if (uiBytes == null) {
      // Encoding failed.
      return null;
    }

    img.Image image = img.Image.fromBytes(
      width: uiImage.width,
      height: uiImage.height,
      bytes: uiBytes.buffer,
      numChannels: 4,
    );
    return image;
  }
}
