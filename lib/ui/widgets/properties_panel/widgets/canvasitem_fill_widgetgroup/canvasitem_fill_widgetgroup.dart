import 'package:flutter/material.dart';
import 'package:gimelstudio/ui/widgets/properties_panel/widgets/expose_property_btn/expose_property_btn.dart';
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
    return Container(
      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0, left: 3.0, right: 8.0), // Avoid scrollbar
      child: Column(
        spacing: 2.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 7.0, bottom: 5.0, top: 2.0),
            child: Row(
              spacing: 4.0,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  property.label.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white54,
                    letterSpacing: -0.03,
                    fontSize: 13.0,
                  ),
                ),
                ExposePropertyBtn(
                  isExposed: property.isExposed,
                  onTap: () => onToggle(property),
                ),
              ],
            ),
          ),
          Row(
            spacing: 4.0,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
            ],
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
