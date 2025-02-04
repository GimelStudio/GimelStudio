import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/node_output.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/models/nodes.dart';
import 'package:gimelstudio/models/photo.dart';
import 'package:gimelstudio/services/node_registry_service.dart';
import 'package:stacked/stacked.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
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
          min: 0,
          max: 100,
          isExposed: false,
        ),
      },
      outputs: {
        'output': Output(id: '', idname: 'output', dataType: int),
      },
    );

    final doubleNode = DoubleNode(
      properties: {
        'number': DoubleProperty(
          id: '',
          idname: 'number',
          label: 'Number',
          dataType: double,
          value: 1.0,
          min: 0.0,
          max: 100.0,
          isExposed: false,
        ),
      },
      outputs: {
        'output': Output(id: '', idname: 'output', dataType: double),
      },
    );

    final rectangleNode = RectangleNode(
      properties: {
        'x': DoubleProperty(
          id: '',
          idname: 'x',
          label: 'X',
          dataType: double,
          value: 0.0,
          min: -10000.0,
          max: 10000.0,
          isExposed: false,
        ),
        'y': DoubleProperty(
          id: '',
          idname: 'y',
          label: 'Y',
          dataType: double,
          value: 0.0,
          min: -10000.0,
          max: 10000.0,
          isExposed: false,
        ),
        'width': DoubleProperty(
          id: '',
          idname: 'width',
          label: 'W',
          dataType: double,
          value: 1.0,
          min: -0.0,
          max: 10000.0,
          isExposed: false,
        ),
        'height': DoubleProperty(
          id: '',
          idname: 'height',
          label: 'H',
          dataType: double,
          value: 1.0,
          min: 0.0,
          max: 10000.0,
          isExposed: false,
        ),
        'rotation': DoubleProperty(
          id: '',
          idname: 'rotation',
          label: 'Rotation',
          dataType: double,
          value: 0.0,
          min: 0.0,
          max: 180.0,
          isExposed: false,
        ),
        'fill': CanvasItemFillProperty(
          id: '',
          idname: 'fill',
          label: 'Fill',
          dataType: CanvasItemFill,
          value: CanvasItemFill(fillType: FillType.solid, solidColor: Colors.purple),
          isExposed: false,
        ),
        'border': CanvasItemBorderProperty(
          id: '',
          idname: 'border',
          label: 'Border',
          dataType: CanvasItemBorder,
          value: CanvasItemBorder(
            fill: CanvasItemFill(fillType: FillType.solid, solidColor: Colors.black),
            thickness: 0.0,
          ),
          isExposed: false,
        ),
        'border_radius': CanvasItemBorderRadiusProperty(
          id: '',
          idname: 'border_radius',
          label: 'Border Radius',
          dataType: CanvasItemBorderRadius,
          value: CanvasItemBorderRadius(
            cornerRadi: (0.0, 0.0, 0.0, 0.0),
            smoothCorners: false,
          ),
          isExposed: false,
        )
      },
      outputs: {
        'output': Output(id: '', idname: 'output', dataType: CanvasItem),
      },
    );

    final textNode = TextNode(
      properties: {
        'x': DoubleProperty(
          id: '',
          idname: 'x',
          label: 'X',
          dataType: double,
          value: 0.0,
          min: -10000.0,
          max: 10000.0,
          isExposed: false,
        ),
        'y': DoubleProperty(
          id: '',
          idname: 'y',
          label: 'Y',
          dataType: double,
          value: 0.0,
          min: -10000.0,
          max: 10000.0,
          isExposed: false,
        ),
        'width': DoubleProperty(
          id: '',
          idname: 'width',
          label: 'W',
          dataType: double,
          value: 0.0,
          min: 0.0,
          max: 10000.0,
          isExposed: false,
        ),
        'height': DoubleProperty(
          id: '',
          idname: 'height',
          label: 'H',
          dataType: double,
          value: 0.0,
          min: 0.0,
          max: 10000.0,
          isExposed: false,
        ),
        //'text':
        'size': DoubleProperty(
          id: '',
          idname: 'size',
          label: 'Size',
          dataType: double,
          value: 0.0,
          min: -10000.0,
          max: 10000.0,
          isExposed: false,
        ),
        'letter_spacing': DoubleProperty(
          id: '',
          idname: 'letter_spacing',
          label: 'Letter spacing',
          dataType: double,
          value: 0.0,
          min: 0.0,
          max: 10.0,
          isExposed: false,
        ),
        'fill': CanvasItemFillProperty(
          id: '',
          idname: 'fill',
          label: 'Fill',
          dataType: CanvasItemFill,
          value: CanvasItemFill(fillType: FillType.solid, solidColor: Colors.black),
          isExposed: false,
        ),
      },
      outputs: {
        'output': Output(id: '', idname: 'output', dataType: CanvasItem),
      },
    );

    final imageNode = ImageNode(
      properties: {
        'x': DoubleProperty(
          id: '',
          idname: 'x',
          label: 'X',
          dataType: double,
          value: 0.0,
          min: -10000.0,
          max: 10000.0,
          isExposed: false,
        ),
        'y': DoubleProperty(
          id: '',
          idname: 'y',
          label: 'Y',
          dataType: double,
          value: 0.0,
          min: -10000.0,
          max: 10000.0,
          isExposed: false,
        ),
        'width': DoubleProperty(
          id: '',
          idname: 'width',
          label: 'W',
          dataType: double,
          value: 0.0,
          min: 0.0,
          max: 10000.0,
          isExposed: false,
        ),
        'height': DoubleProperty(
          id: '',
          idname: 'height',
          label: 'H',
          dataType: double,
          value: 0.0,
          min: 0.0,
          max: 10000.0,
          isExposed: false,
        ),
        'photo': PhotoProperty(
          id: '',
          idname: 'photo',
          label: 'Photo',
          dataType: Photo,
          value: Photo(filePath: '', data: null),
          isExposed: false,
        ),
      },
      outputs: {
        'output': Output(id: '', idname: 'output', dataType: CanvasItem),
      },
    );

    final photoNode = PhotoNode(
      properties: {
        'photo': PhotoProperty(
          id: '',
          idname: 'photo',
          label: 'Photo',
          dataType: Photo,
          value: Photo(filePath: '', data: null),
          isExposed: false,
        ),
      },
      outputs: {
        'output': Output(id: '', idname: 'output', dataType: Photo),
      },
    );

    final blurNode = BlurNode(
      properties: {
        'radius': DoubleProperty(
          id: '',
          idname: 'radius',
          label: 'Radius',
          dataType: double,
          value: 0.0,
          min: 0.0,
          max: 10.0,
          isExposed: false,
        ),
        'photo': PhotoProperty(
          id: '',
          idname: 'photo',
          label: 'Photo',
          dataType: Photo,
          value: Photo(filePath: '', data: null),
          isExposed: false,
        ),
      },
      outputs: {
        'output': Output(id: '', idname: 'output', dataType: Photo),
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
          min: 0,
          max: 100,
          isExposed: true,
        ),
        'b': IntegerProperty(
          id: '',
          idname: 'b',
          label: 'b',
          dataType: int,
          value: 1,
          min: 0,
          max: 100,
          isExposed: true,
        ),
      },
      outputs: {
        'output': Output(id: '', idname: 'output', dataType: int),
      },
    );

    final outputNode = OutputNode(
      properties: {
        'layer': CanvasItemProperty(
          id: '',
          idname: 'layer',
          label: 'Layer',
          dataType: CanvasItem,
          value: 10,
          isExposed: true,
        ),
      },
      outputs: {},
    );

    _nodeRegistryService.registerNodeType(integerNode);
    _nodeRegistryService.registerNodeType(rectangleNode);
    _nodeRegistryService.registerNodeType(textNode);
    _nodeRegistryService.registerNodeType(imageNode);
    _nodeRegistryService.registerNodeType(photoNode);
    _nodeRegistryService.registerNodeType(blurNode);
    _nodeRegistryService.registerNodeType(addNode);
    _nodeRegistryService.registerNodeType(doubleNode);
    _nodeRegistryService.registerNodeType(outputNode);
  }

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    registerNodes();

    _navigationService.replaceWithMainView();
  }
}
