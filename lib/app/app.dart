import 'package:gimelstudio/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:gimelstudio/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:gimelstudio/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:gimelstudio/services/viewport_service.dart';
import 'package:gimelstudio/services/file_service.dart';
import 'package:gimelstudio/services/image_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/ui/views/main/main_view.dart';
import 'package:gimelstudio/services/nodegraphs_service.dart';
import 'package:gimelstudio/services/id_service.dart';
import 'package:gimelstudio/services/node_registry_service.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:gimelstudio/ui/dialogs/new_document/new_document_dialog.dart';
import 'package:gimelstudio/services/export_service.dart';
import 'package:gimelstudio/ui/dialogs/preferences/preferences_dialog.dart';
import 'package:gimelstudio/ui/dialogs/about/about_dialog.dart';
import 'package:gimelstudio/services/cursor_tool_service.dart';
import 'package:gimelstudio/services/rectangle_tool_service.dart';
import 'package:gimelstudio/services/tool_service.dart';
import 'package:gimelstudio/services/overlays_service.dart';
import 'package:gimelstudio/services/hand_tool_service.dart';
import 'package:gimelstudio/services/canvas_service.dart';
import 'package:gimelstudio/services/image_tool_service.dart';
import 'package:gimelstudio/services/text_tool_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: MainView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: ViewportService),
    LazySingleton(classType: FileService),
    LazySingleton(classType: ImageService),
    LazySingleton(classType: LayersService),
    LazySingleton(classType: NodegraphsService),
    LazySingleton(classType: IdService),
    LazySingleton(classType: NodeRegistryService),
    LazySingleton(classType: DocumentService),
    LazySingleton(classType: EvaluationService),
    LazySingleton(classType: ExportService),
    LazySingleton(classType: CursorToolService),
    LazySingleton(classType: RectangleToolService),
    LazySingleton(classType: ToolService),
    LazySingleton(classType: OverlaysService),
    LazySingleton(classType: HandToolService),
    LazySingleton(classType: CanvasService),
    LazySingleton(classType: ImageToolService),
    LazySingleton(classType: TextToolService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    StackedDialog(classType: NewDocumentDialog),
    StackedDialog(classType: PreferencesDialog),
    StackedDialog(classType: AboutDialog),
// @stacked-dialog
  ],
)
class App {}