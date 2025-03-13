import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:gimelstudio/services/viewport_service.dart';
import 'package:gimelstudio/services/file_service.dart';
import 'package:gimelstudio/services/image_service.dart';
import 'package:gimelstudio/services/layers_service.dart';
import 'package:gimelstudio/services/nodegraphs_service.dart';
import 'package:gimelstudio/services/id_service.dart';
import 'package:gimelstudio/services/node_registry_service.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/evaluation_service.dart';
import 'package:gimelstudio/services/export_service.dart';
import 'package:gimelstudio/services/cursor_tool_service.dart';
import 'package:gimelstudio/services/rectangle_tool_service.dart';
import 'package:gimelstudio/services/tool_service.dart';
import 'package:gimelstudio/services/overlays_service.dart';
import 'package:gimelstudio/services/hand_tool_service.dart';
import 'package:gimelstudio/services/canvas_service.dart';
import 'package:gimelstudio/services/image_tool_service.dart';
import 'package:gimelstudio/services/text_tool_service.dart';
import 'package:gimelstudio/services/open_file_service.dart';
import 'package:gimelstudio/services/canvas_item_service.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<BottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ViewportService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<FileService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ImageService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<LayersService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<NodegraphsService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<IdService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<NodeRegistryService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DocumentService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<EvaluationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ExportService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<CursorToolService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<RectangleToolService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ToolService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<OverlaysService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<HandToolService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<CanvasService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ImageToolService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<TextToolService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<OpenFileService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<CanvasItemService>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-mock-spec
])
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterViewportService();
  getAndRegisterFileService();
  getAndRegisterImageService();
  getAndRegisterLayersService();
  getAndRegisterNodegraphsService();
  getAndRegisterIdService();
  getAndRegisterNodeRegistryService();
  getAndRegisterDocumentService();
  getAndRegisterEvaluationService();
  getAndRegisterExportService();
  getAndRegisterCursorToolService();
  getAndRegisterRectangleToolService();
  getAndRegisterToolService();
  getAndRegisterOverlaysService();
  getAndRegisterHandToolService();
  getAndRegisterCanvasService();
  getAndRegisterImageToolService();
  getAndRegisterTextToolService();
  getAndRegisterOpenFileService();
  getAndRegisterCanvasItemService();
// @stacked-mock-register
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();

  when(service.showCustomSheet<T, T>(
    enableDrag: anyNamed('enableDrag'),
    enterBottomSheetDuration: anyNamed('enterBottomSheetDuration'),
    exitBottomSheetDuration: anyNamed('exitBottomSheetDuration'),
    ignoreSafeArea: anyNamed('ignoreSafeArea'),
    isScrollControlled: anyNamed('isScrollControlled'),
    barrierDismissible: anyNamed('barrierDismissible'),
    additionalButtonTitle: anyNamed('additionalButtonTitle'),
    variant: anyNamed('variant'),
    title: anyNamed('title'),
    hasImage: anyNamed('hasImage'),
    imageUrl: anyNamed('imageUrl'),
    showIconInMainButton: anyNamed('showIconInMainButton'),
    mainButtonTitle: anyNamed('mainButtonTitle'),
    showIconInSecondaryButton: anyNamed('showIconInSecondaryButton'),
    secondaryButtonTitle: anyNamed('secondaryButtonTitle'),
    showIconInAdditionalButton: anyNamed('showIconInAdditionalButton'),
    takesInput: anyNamed('takesInput'),
    barrierColor: anyNamed('barrierColor'),
    barrierLabel: anyNamed('barrierLabel'),
    customData: anyNamed('customData'),
    data: anyNamed('data'),
    description: anyNamed('description'),
  )).thenAnswer((realInvocation) => Future.value(showCustomSheetResponse ?? SheetResponse<T>()));

  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockViewportService getAndRegisterViewportService() {
  _removeRegistrationIfExists<ViewportService>();
  final service = MockViewportService();
  locator.registerSingleton<ViewportService>(service);
  return service;
}

MockFileService getAndRegisterFileService() {
  _removeRegistrationIfExists<FileService>();
  final service = MockFileService();
  locator.registerSingleton<FileService>(service);
  return service;
}

MockImageService getAndRegisterImageService() {
  _removeRegistrationIfExists<ImageService>();
  final service = MockImageService();
  locator.registerSingleton<ImageService>(service);
  return service;
}

MockLayersService getAndRegisterLayersService() {
  _removeRegistrationIfExists<LayersService>();
  final service = MockLayersService();
  locator.registerSingleton<LayersService>(service);
  return service;
}

MockNodegraphsService getAndRegisterNodegraphsService() {
  _removeRegistrationIfExists<NodegraphsService>();
  final service = MockNodegraphsService();
  locator.registerSingleton<NodegraphsService>(service);
  return service;
}

MockIdService getAndRegisterIdService() {
  _removeRegistrationIfExists<IdService>();
  final service = MockIdService();
  locator.registerSingleton<IdService>(service);
  return service;
}

MockNodeRegistryService getAndRegisterNodeRegistryService() {
  _removeRegistrationIfExists<NodeRegistryService>();
  final service = MockNodeRegistryService();
  locator.registerSingleton<NodeRegistryService>(service);
  return service;
}

MockDocumentService getAndRegisterDocumentService() {
  _removeRegistrationIfExists<DocumentService>();
  final service = MockDocumentService();
  locator.registerSingleton<DocumentService>(service);
  return service;
}

MockEvaluationService getAndRegisterEvaluationService() {
  _removeRegistrationIfExists<EvaluationService>();
  final service = MockEvaluationService();
  locator.registerSingleton<EvaluationService>(service);
  return service;
}

MockExportService getAndRegisterExportService() {
  _removeRegistrationIfExists<ExportService>();
  final service = MockExportService();
  locator.registerSingleton<ExportService>(service);
  return service;
}

MockCursorToolService getAndRegisterCursorToolService() {
  _removeRegistrationIfExists<CursorToolService>();
  final service = MockCursorToolService();
  locator.registerSingleton<CursorToolService>(service);
  return service;
}

MockRectangleToolService getAndRegisterRectangleToolService() {
  _removeRegistrationIfExists<RectangleToolService>();
  final service = MockRectangleToolService();
  locator.registerSingleton<RectangleToolService>(service);
  return service;
}

MockToolService getAndRegisterToolService() {
  _removeRegistrationIfExists<ToolService>();
  final service = MockToolService();
  locator.registerSingleton<ToolService>(service);
  return service;
}

MockOverlaysService getAndRegisterOverlaysService() {
  _removeRegistrationIfExists<OverlaysService>();
  final service = MockOverlaysService();
  locator.registerSingleton<OverlaysService>(service);
  return service;
}

MockHandToolService getAndRegisterHandToolService() {
  _removeRegistrationIfExists<HandToolService>();
  final service = MockHandToolService();
  locator.registerSingleton<HandToolService>(service);
  return service;
}

MockCanvasService getAndRegisterCanvasService() {
  _removeRegistrationIfExists<CanvasService>();
  final service = MockCanvasService();
  locator.registerSingleton<CanvasService>(service);
  return service;
}

MockImageToolService getAndRegisterImageToolService() {
  _removeRegistrationIfExists<ImageToolService>();
  final service = MockImageToolService();
  locator.registerSingleton<ImageToolService>(service);
  return service;
}

MockTextToolService getAndRegisterTextToolService() {
  _removeRegistrationIfExists<TextToolService>();
  final service = MockTextToolService();
  locator.registerSingleton<TextToolService>(service);
  return service;
}

MockOpenFileService getAndRegisterOpenFileService() {
  _removeRegistrationIfExists<OpenFileService>();
  final service = MockOpenFileService();
  locator.registerSingleton<OpenFileService>(service);
  return service;
}

MockCanvasItemService getAndRegisterCanvasItemService() {
  _removeRegistrationIfExists<CanvasItemService>();
  final service = MockCanvasItemService();
  locator.registerSingleton<CanvasItemService>(service);
  return service;
}
// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
