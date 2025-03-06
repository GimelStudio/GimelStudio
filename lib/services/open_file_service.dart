import 'dart:convert';
import 'dart:ui';

import 'package:file_selector/file_selector.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/models/nodegraph.dart';
import 'package:gimelstudio/services/file_service.dart';
import 'package:gimelstudio/services/id_service.dart';
import 'package:gimelstudio/ui/common/constants.dart';
import 'package:gimelstudio/ui/common/enums.dart';
import 'package:image/image.dart' as img;

class OpenFileService {
  final _idService = locator<IdService>();
  final _fileService = locator<FileService>();

  Future<Document?> openFilePathAsDocument(String filePath) async {
    String extension = filePath.split('.').last;
    SupportedFileFormat? fileFormat = _fileService.fileExtensionToFileFormat(extension);
    if (fileFormat == null) {
      return null; // Unsupported file
    }

    // Raster file format
    if (Constants.supportedRasterFileFormats.contains(fileFormat.name)) {
      return await openRasterFileAsDocument(filePath);
    } else {
      // .gimel document
      return await openGimelFileAsDocument(filePath);
    }
  }

  Future<Document?> openRasterFileAsDocument(String filePath) async {
    img.Image? image = await img.decodeImageFile(filePath);

    if (image == null) {
      return null;
    }

    String fileName = XFile(filePath).name;
    int imageWidth = image.width;
    int imageHeight = image.height;

    // Create a new document the same size as the image.
    Document newDocument = Document(
      id: _idService.newId(),
      name: fileName,
      path: filePath,
      size: Size(imageWidth.toDouble(), imageHeight.toDouble()),
      layers: [
        Layer(
          id: _idService.newId(),
          index: 0,
          name: fileName,
          selected: true,
          visible: true,
          locked: false,
          opacity: 100,
          blend: 'Normal',
          nodegraph: NodeGraph(
            id: _idService.newId(),
            nodes: {}, // defaultNodes,
          ),
        ),
      ],
      selectedLayers: [],
    );

    // TODO

    return newDocument;
  }

  Future<Document> openGimelFileAsDocument(String filePath) async {
    final XFile file = XFile(filePath);
    String fileContents = await file.readAsString();
    Document openedDocument = Document.fromJson(jsonDecode(fileContents));

    return openedDocument;
  }
}
