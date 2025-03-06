import 'package:gimelstudio/app/app.dialogs.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TopBarModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();

  bool _showMenu = true;
  bool get showMenu => _showMenu;

  Future<void> onIcon() async {
    await _dialogService.showCustomDialog(
      variant: DialogType.about,
    );
  }

  void onToggleShowMenu() {
    _showMenu = !_showMenu;
    rebuildUi();
  }
}
