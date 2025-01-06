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
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
