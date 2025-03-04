import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/tool.dart';
import 'package:gimelstudio/services/cursor_tool_service.dart';
import 'package:gimelstudio/services/hand_tool_service.dart';
import 'package:gimelstudio/services/image_tool_service.dart';
import 'package:gimelstudio/services/rectangle_tool_service.dart';
import 'package:gimelstudio/services/text_tool_service.dart';
import 'package:stacked/stacked.dart';

class ToolService with ListenableServiceMixin {
  final _cursorToolService = locator<CursorToolService>();
  final _handToolService = locator<HandToolService>();
  final _rectangleToolService = locator<RectangleToolService>();
  final _textToolService = locator<TextToolService>();
  final _imageToolService = locator<ImageToolService>();

  ToolService() {
    listenToReactiveValues([
      _activeTool,
      _toolModeHandler,
    ]);
  }

  Tool _activeTool = Tool.cursor;
  Tool get activeTool => _activeTool;

  ToolModeEventHandler _toolModeHandler = ToolModeEventHandler();
  ToolModeEventHandler get toolModeHandler => _toolModeHandler;

  void setActiveTool(Tool tool) {
    _activeTool = tool;
  }

  void setToolEventHandler(Tool tool) {
    _toolModeHandler = getToolModeHandler(tool);
  }

  ToolModeEventHandler getToolModeHandler(Tool activeTool) {
    switch (activeTool) {
      case Tool.cursor:
        return _cursorToolService;
      case Tool.hand:
        return _handToolService;
      case Tool.rectangle:
        return _rectangleToolService;
      case Tool.text:
        return _textToolService;
      case Tool.image:
        return _imageToolService;
      default:
        return _cursorToolService;
    }
  }
}
