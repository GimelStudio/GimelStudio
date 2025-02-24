// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_shared/stacked_shared.dart';

import '../services/canvas_service.dart';
import '../services/cursor_tool_service.dart';
import '../services/document_service.dart';
import '../services/evaluation_service.dart';
import '../services/export_service.dart';
import '../services/file_service.dart';
import '../services/hand_tool_service.dart';
import '../services/id_service.dart';
import '../services/image_service.dart';
import '../services/layers_service.dart';
import '../services/node_registry_service.dart';
import '../services/nodegraphs_service.dart';
import '../services/overlays_service.dart';
import '../services/rectangle_tool_service.dart';
import '../services/tool_service.dart';
import '../services/viewport_service.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
// Register environments
  locator.registerEnvironment(environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => ViewportService());
  locator.registerLazySingleton(() => FileService());
  locator.registerLazySingleton(() => ImageService());
  locator.registerLazySingleton(() => LayersService());
  locator.registerLazySingleton(() => NodegraphsService());
  locator.registerLazySingleton(() => IdService());
  locator.registerLazySingleton(() => NodeRegistryService());
  locator.registerLazySingleton(() => DocumentService());
  locator.registerLazySingleton(() => EvaluationService());
  locator.registerLazySingleton(() => ExportService());
  locator.registerLazySingleton(() => CursorToolService());
  locator.registerLazySingleton(() => RectangleToolService());
  locator.registerLazySingleton(() => ToolService());
  locator.registerLazySingleton(() => OverlaysService());
  locator.registerLazySingleton(() => HandToolService());
  locator.registerLazySingleton(() => CanvasService());
}
