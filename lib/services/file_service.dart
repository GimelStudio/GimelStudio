//import 'package:image_picker/image_picker.dart';

//import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:gimelstudio/ui/common/platform.dart';

class FileService {
  // Future<XFile?> selectFile() async {
  //   final picker = ImagePicker();
  //   return await picker.pickImage(source: ImageSource.gallery);
  // }

  Future<String?> getSaveFilePath({suggestedName = 'untitled'}) async {
    // TODO: this does not work on web.
    final FileSaveLocation? result = await getSaveLocation(
      acceptedTypeGroups: [
        const XTypeGroup(label: 'JPEG Files', mimeTypes: [
          'image/jpeg',
        ], extensions: [
          'jpg',
          'jpeg'
        ]),
        const XTypeGroup(label: 'PNG Files', mimeTypes: ['image/png'], extensions: ['png']),
        const XTypeGroup(label: 'GIF Files', mimeTypes: ['image/gif'], extensions: ['gif']),
        const XTypeGroup(label: 'BMP Files', mimeTypes: ['image/bmp'], extensions: ['bmp']),
        const XTypeGroup(label: 'TIFF Files', mimeTypes: ['image/tiff'], extensions: ['tiff']),
        const XTypeGroup(label: 'TGA Files', mimeTypes: ['image/tga'], extensions: ['tga']),
        const XTypeGroup(label: 'ICO Files', mimeTypes: ['image/ico'], extensions: ['ico']),
      ],
      suggestedName: suggestedName,
    );

    return result?.path;
  }

  Future<void> saveFile(String content) async {
    // log(_documentsService.documents[_documentsService.selectedDocumentIndex].toJson().toString());
    // var file = File('C:/Users/Acer/Downloads/test.gimel');
    // await file.writeAsString(content);
  }
}
