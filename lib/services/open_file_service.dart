import 'dart:convert';
import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/models/node_base.dart';
import 'package:gimelstudio/models/nodegraph.dart';
import 'package:gimelstudio/models/photo.dart';
import 'package:gimelstudio/services/file_service.dart';
import 'package:gimelstudio/services/id_service.dart';
import 'package:gimelstudio/services/node_registry_service.dart';
import 'package:gimelstudio/ui/common/constants.dart';
import 'package:gimelstudio/ui/common/enums.dart';
import 'package:image/image.dart' as img;

class OpenFileService {
  final _idService = locator<IdService>();
  final _fileService = locator<FileService>();
  final _nodeRegistryService = locator<NodeRegistryService>();

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

    XFile file = XFile(filePath);
    String fileName = file.name;
    double imageWidth = image.width.toDouble();
    double imageHeight = image.height.toDouble();

    // TODO: refactor
    Map<String, Node> defaultNodes = _nodeRegistryService.newDefaultNodes('image', fileName);

    Node outputNode = defaultNodes.values.firstWhere((item) => item.isLayerOutput == true);
    Node photoNode = defaultNodes.values.firstWhere((item) => item.idname == 'photo_corenode');
    Node imageNode = defaultNodes.values.firstWhere((item) => item.idname == 'image_corenode');

    Uint8List bytes = await file.readAsBytes();
    Photo photo = Photo(filePath: file.path, data: bytes);
    photo.uiData = await photo.toCanvasImageData();

    photoNode.setPropertyValue('photo', photo);
    imageNode.setConnection('photo', photoNode, 'output');
    imageNode.setPropertyValue('width', imageWidth);
    imageNode.setPropertyValue('height', imageHeight);
    outputNode.setConnection('layer', imageNode, 'output');

    Layer layer = Layer(
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
        nodes: defaultNodes,
      ),
    );

    // Create a new document the same size as the image.
    Document newDocument = Document(
      id: _idService.newId(),
      name: fileName,
      path: filePath,
      size: Size(imageWidth, imageHeight),
      background: Colors.transparent, // For directly opened images, set the background to transparent
      layers: [layer],
      selectedLayers: [layer],
    );

    return newDocument;
  }

  Future<Document> openGimelFileAsDocument(String filePath) async {
    final XFile file = XFile(filePath);
    String fileContents = await file.readAsString();
    Document openedDocument = Document.fromJson(jsonDecode(fileContents));

    return openedDocument;
  }
}
