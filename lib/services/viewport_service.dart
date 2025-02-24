import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/tool.dart';
import 'package:gimelstudio/services/tool_service.dart';
import 'package:stacked/stacked.dart';

/// The tool services cannot import the tool or this
/// viewport service because either would be recursive imports.
class ViewportService with ListenableServiceMixin {
  final _toolService = locator<ToolService>();

  ViewportService() {
    listenToReactiveValues([
      activeTool,
      toolModeHandler,
    ]);
  }

  Tool get activeTool => _toolService.activeTool;
  ToolModeEventHandler get toolModeHandler => _toolService.toolModeHandler;

  void setActiveTool(Tool tool) {
    toolModeHandler.deactivate();
    _toolService.setActiveTool(tool);
    _toolService.setToolEventHandler(tool);
    toolModeHandler.activate();
    notifyListeners();
  }
}
