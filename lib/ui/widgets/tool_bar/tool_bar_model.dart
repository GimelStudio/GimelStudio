import 'package:gimelstudio/models/tool.dart';
import 'package:stacked/stacked.dart';

class ToolBarModel extends BaseViewModel {
  Tool _currentTool = Tool.cursor;
  Tool get currentTool => _currentTool;

  // TODO: move to viewport service
  void onSelectTool(Tool tool) {
    _currentTool = tool;
    rebuildUi();
  }
}
