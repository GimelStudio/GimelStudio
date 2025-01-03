import 'package:gimelstudio/app/app.bottomsheets.dart';
import 'package:gimelstudio/app/app.dialogs.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MainViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();

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
