import 'package:opencv_core/opencv.dart' as cv;

import 'package:gimelstudio/app/app.bottomsheets.dart';
import 'package:gimelstudio/app/app.dialogs.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/services/file_service.dart';
import 'package:gimelstudio/services/image_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MainViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _imageService = locator<ImageService>();
  final _fileService = locator<FileService>();

  String get imageFileName => getImageFileName(_imageService.imagePath);
  String get imageWidthHeight => getImageWidthHeight(_imageService.imageMat);

  Future<void> onChangeImageBtn() async {
    XFile? file = await _fileService.selectFile();
    if (file != null) {
      _imageService.loadImageMatFromPath(file.path);
    } else {
      print('Cancelled choosing file');
    }
    rebuildUi();
  }

  String getImageFileName(String path) {
    return path.split('\\').last;
  }

  String getImageWidthHeight(cv.Mat? mat) {
    return mat == null ? '' : '(${mat.cols}x${mat.rows})';
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Dialog',
      description: '...',
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: 'Bottom sheet',
      description: '...',
    );
  }
}
