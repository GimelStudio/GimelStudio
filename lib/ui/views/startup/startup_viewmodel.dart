import 'package:flutter/material.dart';
import 'package:gimelstudio/models/node_output.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/models/nodes.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/node_registry_service.dart';
import 'package:stacked/stacked.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _documentsService = locator<DocumentService>();
  final _nodeRegistryService = locator<NodeRegistryService>();

  void registerNodes() {
    final integerNode = IntegerNode(
      properties: {
        'number': IntegerProperty(
          id: '',
          idname: 'number',
          label: 'Number',
          dataType: int,
          value: 21,
          isExposed: false,
        ),
      },
      outputs: {
        'output': Output(id: '', idname: 'output', dataType: int),
      },
    );

    final rectangleNode = RectangleNode(
      properties: {
        'x': IntegerProperty(
          id: '',
          idname: 'x',
          label: 'X',
          dataType: int,
          value: 11,
          isExposed: false,
        ),
        'y': IntegerProperty(
          id: '',
          idname: 'y',
          label: 'Y',
          dataType: int,
          value: 11,
          isExposed: false,
        ),
        'width': IntegerProperty(
          id: '',
          idname: 'width',
          label: 'W',
          dataType: int,
          value: 400,
          isExposed: false,
        ),
        'height': IntegerProperty(
          id: '',
          idname: 'height',
          label: 'H',
          dataType: int,
          value: 400,
          isExposed: false,
        ),
      },
      outputs: {
        'output': Output(id: '', idname: 'output', dataType: int),
      },
    );

    final addNode = AddNode(
      properties: {
        'a': IntegerProperty(
          id: '',
          idname: 'a',
          label: 'a',
          dataType: int,
          value: 1,
          isExposed: true,
        ),
        'b': IntegerProperty(
          id: '',
          idname: 'b',
          label: 'b',
          dataType: int,
          value: 1,
          isExposed: true,
        ),
      },
      outputs: {
        'output': Output(id: '', idname: 'output', dataType: int),
      },
    );

    final outputNode = OutputNode(
      properties: {
        'layer': IntegerProperty(
          id: '',
          idname: 'layer',
          label: 'Layer',
          dataType: int,
          value: 10,
          isExposed: true,
        ),
      },
      outputs: {},
    );

    final outputNode2 = OutputNode2(
      properties: {
        'layer': IntegerProperty(
          id: '',
          idname: 'layer',
          label: 'Layer',
          dataType: int,
          value: 10,
          isExposed: true,
        ),
      },
      outputs: {},
    );

    _nodeRegistryService.registerNodeType(integerNode);
    _nodeRegistryService.registerNodeType(rectangleNode);
    _nodeRegistryService.registerNodeType(addNode);
    _nodeRegistryService.registerNodeType(outputNode);
    _nodeRegistryService.registerNodeType(outputNode2);
  }

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic

    registerNodes();

    // TODO: these documents are created here for testing.
    // In the real application the documents will be created or
    // opened by the user.
    // _documentsService.createNewDocument('Untitled', Size(1920, 1080));
    // _documentsService.createNewDocument('Nature project', Size(2048, 2048));

    _navigationService.replaceWithMainView();
  }
}
