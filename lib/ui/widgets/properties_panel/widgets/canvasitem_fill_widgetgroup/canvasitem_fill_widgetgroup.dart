import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../../../models/canvas_item.dart';
import '../../../../../models/node_property.dart';
import '../../../common/gs_color_picker/gs_color_picker.dart';
import 'canvasitem_fill_widgetgroup_model.dart';

class CanvasitemFillWidgetgroup extends StackedView<CanvasitemFillWidgetgroupModel> {
  const CanvasitemFillWidgetgroup({
    super.key,
    required this.property,
    required this.onChangeValue,
    required this.onToggle,
  });

  final CanvasItemFillProperty property;
  final Function(CanvasItemFillProperty, CanvasItemFill) onChangeValue;
  final Function(CanvasItemFillProperty) onToggle;

  @override
  Widget builder(
    BuildContext context,
    CanvasitemFillWidgetgroupModel viewModel,
    Widget? child,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        spacing: 4.0,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            property.label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14.0,
            ),
          ),
          Expanded(
            child: Visibility(
              visible: property.isExposed == false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: GsColorPicker(
                // canvasFill: CanvasItemFill(
                //   fillType: FillType.linearGradient,
                //   solidColor: Colors.red.withAlpha(100),
                // ),
                canvasFill: property.value as CanvasItemFill,
                onChange: (value) {},
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: HueRingPicker(
              //         pickerColor: val.solidColor,
              //         onColorChanged: (Color color) {
              //           var c = item.CanvasItemFill(
              //               fillType: item.FillType.solid, solidColor: color);
              //           viewModel.setPropertyValue(property, c);
              //         },
              //       ),
              //     ),
              //   ],
              // ),
            ),
          ),
          InkWell(
            // TODO: eventually this will be a menu with the option to reset to the default value as well.
            onTap: () => onToggle(property),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: PhosphorIcon(
                PhosphorIcons.diamond(property.isExposed ? PhosphorIconsStyle.fill : PhosphorIconsStyle.light),
                color: Colors.white70,
                size: 10.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  CanvasitemFillWidgetgroupModel viewModelBuilder(
    BuildContext context,
  ) =>
      CanvasitemFillWidgetgroupModel();
}
