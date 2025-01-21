import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/models/tool.dart';
import 'package:gimelstudio/services/viewport_service.dart';
import 'package:stacked/stacked.dart';

class ToolBarModel extends ReactiveViewModel {
  final _viewportService = locator<ViewportService>();

  Tool get activeTool => _viewportService.activeTool;

  void onSelectTool(Tool tool) {
    _viewportService.setActiveTool(tool);
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_viewportService];
}
