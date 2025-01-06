import 'package:flutter/material.dart';
import 'package:gimelstudio/models/node_output.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/models/nodes.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:gimelstudio/services/id_service.dart';
import 'package:gimelstudio/services/node_registry_service.dart';
import 'package:stacked/stacked.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _documentsService = locator<DocumentService>();
  final _nodeRegistryService = locator<NodeRegistryService>();
  final _idService = locator<IdService>();

  void registerNodes() {
    final integerNode = IntegerNode(
      properties: {
        'number': IntegerProperty(id: _idService.newId(), idname: 'number', dataType: int, value: 21, isExposed: false),
      },
      outputs: {
        'output': Output(name: 'output', dataType: int),
      },
    );

    final addNode = AddNode(
      properties: {
        'a': IntegerProperty(id: _idService.newId(), idname: 'a', dataType: int, value: 0, isExposed: true),
        'b': IntegerProperty(id: _idService.newId(), idname: 'b', dataType: int, value: 0, isExposed: true),
      },
      outputs: {
        'output': Output(name: 'output', dataType: int),
      },
    );

    final outputNode = OutputNode(
      properties: {
        'final': IntegerProperty(id: _idService.newId(), idname: 'final', dataType: int, value: 10, isExposed: true),
      },
      outputs: {},
    );

    final outputNode2 = OutputNode2(
      properties: {
        'final': IntegerProperty(id: _idService.newId(), idname: 'final', dataType: int, value: 10, isExposed: true),
      },
      outputs: {},
    );

    _nodeRegistryService.registerNodeType(integerNode);
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
    _documentsService.createNewDocument('Untitled', Size(1920, 1080));
    _documentsService.createNewDocument('Nature project', Size(2048, 2048));

    _navigationService.replaceWithMainView();
  }
}
