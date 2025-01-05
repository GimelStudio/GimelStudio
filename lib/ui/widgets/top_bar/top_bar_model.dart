import 'package:stacked/stacked.dart';

class TopBarModel extends BaseViewModel {
  bool _showMenu = true;
  bool get showMenu => _showMenu;

  void onToggleShowMenu() {
    _showMenu = !_showMenu;
    rebuildUi();
  }
}
