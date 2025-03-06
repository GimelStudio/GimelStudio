import 'package:file_selector/file_selector.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gimelstudio/ui/common/constants.dart';
import 'package:gimelstudio/ui/common/enums.dart';

class FileService {
  Future<String?> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: Constants.supportedReadFileFormats,
    );
    if (result == null) {
      return null;
    }
    return result.files.single.path!;
  }

  Future<String?> getSaveFilePath({suggestedName = 'untitled.jpg'}) async {
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

  /// Converts an image extension [extension] to a value of the SupportedFileFormat enum.
  ///
  /// null is returned if there is no matching image format in SupportedFileFormat.
  /// The parameter [extension] should not include the period.
  SupportedFileFormat? fileExtensionToFileFormat(String extension) {
    SupportedFileFormat? fileFormat;

    switch (extension.toLowerCase()) {
      case 'gimel':
        fileFormat = SupportedFileFormat.gimel;
      case 'jpg':
        fileFormat = SupportedFileFormat.jpg;
      case 'jpeg':
        fileFormat = SupportedFileFormat.jpg;
      case 'png':
        fileFormat = SupportedFileFormat.png;
      case 'gif':
        fileFormat = SupportedFileFormat.gif;
      case 'bmp':
        fileFormat = SupportedFileFormat.bmp;
      case 'tiff':
        fileFormat = SupportedFileFormat.tiff;
      case 'tga':
        fileFormat = SupportedFileFormat.tga;
      case 'ico':
        fileFormat = SupportedFileFormat.ico;
      default:
        // Unsupported
        fileFormat = null;
    }
    return fileFormat;
  }
}
