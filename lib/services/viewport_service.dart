import 'package:gimelstudio/models/tool.dart';
import 'package:stacked/stacked.dart';

class ViewportService with ListenableServiceMixin {
  ViewportService() {
    listenToReactiveValues([
      _activeTool,
    ]);
  }

  Tool _activeTool = Tool.cursor;
  Tool get activeTool => _activeTool;

  void setActiveTool(Tool tool) {
    _activeTool = tool;
    notifyListeners();
  }
}
