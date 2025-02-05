import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/ui/widgets/common/gs_color_picker/gs_color_picker.dart';
import 'package:gimelstudio/ui/widgets/common/gs_double_input/gs_double_input.dart';
import 'package:gimelstudio/ui/widgets/properties_panel/widgets/expose_property_btn/expose_property_btn.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import 'canvasitem_border_widgetgroup_model.dart';

class CanvasitemBorderWidgetgroup extends StackedView<CanvasitemBorderWidgetgroupModel> {
  const CanvasitemBorderWidgetgroup({
    super.key,
    required this.property,
    required this.onChangeValue,
    required this.onToggle,
  });

  final CanvasItemBorderProperty property;
  final Function(CanvasItemBorderProperty, CanvasItemBorder) onChangeValue;
  final Function(CanvasItemBorderProperty) onToggle;

  @override
  Widget builder(
    BuildContext context,
    CanvasitemBorderWidgetgroupModel viewModel,
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
                    canvasFill: property.value.fill as CanvasItemFill,
                    onChange: (value) {},
                  ),
                ),
              ),
            ],
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
                  child: GsDoubleInput(
                    startIcon: PhosphorIcon(
                      PhosphorIcons.stop(PhosphorIconsStyle.light),
                      color: Colors.white70,
                      size: 16.0,
                    ),
                    currentValue: property.value.thickness,
                    minValue: 0.0,
                    maxValue: 500.0,
                    onChange: (value) => onChangeValue(
                      property,
                      CanvasItemBorder(
                        fill: CanvasItemFill(fillType: FillType.solid, solidColor: Colors.black),
                        thickness: value,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  CanvasitemBorderWidgetgroupModel viewModelBuilder(
    BuildContext context,
  ) =>
      CanvasitemBorderWidgetgroupModel();
}
