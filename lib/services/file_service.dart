//import 'package:image_picker/image_picker.dart';

import 'dart:io';

class FileService {
  // Future<XFile?> selectFile() async {
  //   final picker = ImagePicker();
  //   return await picker.pickImage(source: ImageSource.gallery);
  // }

  Future<void> saveFile(String content) async {
    // log(_documentsService.documents[_documentsService.selectedDocumentIndex].toJson().toString());
    var file = File('C:/Users/Acer/Downloads/test.gimel');
    await file.writeAsString(content);
  }
}
