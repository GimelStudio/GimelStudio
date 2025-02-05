import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/ui/widgets/common/gs_double_input/gs_double_input.dart';
import 'package:gimelstudio/ui/widgets/common/gs_icon_btn/gs_icon_btn.dart';
import 'package:gimelstudio/ui/widgets/properties_panel/widgets/expose_property_btn/expose_property_btn.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import 'canvasitem_widgetgroup_model.dart';

class CanvasitemWidgetgroup extends StackedView<CanvasitemWidgetgroupModel> {
  const CanvasitemWidgetgroup({
    super.key,
    required this.xProperty,
    required this.yProperty,
    required this.widthProperty,
    required this.heightProperty,
    required this.rotationProperty,
    required this.borderRadiusProperty,
    required this.onChangeValue,
    required this.onToggle,
  });

  final DoubleProperty? xProperty;
  final DoubleProperty? yProperty;
  final DoubleProperty? widthProperty;
  final DoubleProperty? heightProperty;
  final DoubleProperty? rotationProperty;
  final CanvasItemBorderRadiusProperty? borderRadiusProperty;
  final Function(Property, dynamic) onChangeValue;
  final Function(Property) onToggle;

  @override
  Widget builder(
    BuildContext context,
    CanvasitemWidgetgroupModel viewModel,
    Widget? child,
  ) {
    return Container(
      padding: const EdgeInsets.only(bottom: 3.0, left: 3.0, right: 8.0), // Avoid scrollbar
      child: Column(
        spacing: 4.0,
        children: [
          // X, Y
          Row(
            spacing: 6.0,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (DoubleProperty? property in [xProperty, yProperty])
                if (property != null)
                  Expanded(
                    child: Row(
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
                              label: property.label,
                              currentValue: property.value,
                              minValue: property.min,
                              maxValue: property.max,
                              onChange: (value) => onChangeValue(property, value),
                            ),
                          ),
                        ),
                        ExposePropertyBtn(
                          isExposed: property.isExposed,
                          onTap: () => onToggle(property),
                        ),
                      ],
                    ),
                  ),

              // Spacer
              const SizedBox(width: 28.0, height: 24.0),
            ],
          ),
          // W, H
          Row(
            spacing: 6.0,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (DoubleProperty? property in [widthProperty, heightProperty])
                if (property != null)
                  Expanded(
                    child: Row(
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
                              label: property.label,
                              currentValue: property.value,
                              minValue: property.min,
                              maxValue: property.max,
                              onChange: (value) => onChangeValue(property, value),
                            ),
                          ),
                        ),
                        ExposePropertyBtn(
                          isExposed: property.isExposed,
                          onTap: () => onToggle(property),
                        ),
                      ],
                    ),
                  ),

              // Lock aspect ratio
              // TODO:
              // - This needs a BoolProperty
              // - Locking aspect ratio needs to be implemented
              GsIconBtn(
                icon: PhosphorIcon(
                  PhosphorIcons.lockSimpleOpen(PhosphorIconsStyle.light),
                  color: Colors.white,
                  size: 16.0,
                ),
                onTap: () {},
              ),
            ],
          ),

          // Rotation, Border radius
          Row(
            spacing: 6.0,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (rotationProperty != null)
                Expanded(
                  child: Row(
                    spacing: 4.0,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Visibility(
                          visible: rotationProperty!.isExposed == false,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: GsDoubleInput(
                            startIcon: PhosphorIcon(
                              PhosphorIcons.angle(PhosphorIconsStyle.light),
                              color: Colors.white70,
                              size: 16.0,
                            ),
                            currentValue: rotationProperty!.value,
                            minValue: rotationProperty!.min,
                            maxValue: rotationProperty!.max,
                            formatter: '%f°',
                            onChange: (value) => onChangeValue(rotationProperty!, value),
                          ),
                        ),
                      ),
                      ExposePropertyBtn(
                        isExposed: rotationProperty!.isExposed,
                        onTap: () => onToggle(rotationProperty!),
                      ),
                    ],
                  ),
                ),
              if (borderRadiusProperty != null)
                Expanded(
                  child: Row(
                    spacing: 4.0,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Visibility(
                          visible: borderRadiusProperty!.isExposed == false,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: GsDoubleInput(
                            startIcon: PhosphorIcon(
                              PhosphorIcons.circleNotch(PhosphorIconsStyle.light),
                              color: Colors.white70,
                              size: 16.0,
                            ),
                            currentValue: borderRadiusProperty!.value.cornerRadi.$1,
                            minValue: 0.0,
                            maxValue: 500.0,
                            onChange: (value) => onChangeValue(
                              borderRadiusProperty!,
                              CanvasItemBorderRadius(cornerRadi: (value, value, value, value)),
                            ),
                          ),
                        ),
                      ),
                      ExposePropertyBtn(
                        isExposed: borderRadiusProperty!.isExposed,
                        onTap: () => onToggle(borderRadiusProperty!),
                      ),
                    ],
                  ),
                ),

              // Spacer
              const SizedBox(width: 28.0, height: 24.0),
            ],
          ),
        ],
      ),
    );
  }

  @override
  CanvasitemWidgetgroupModel viewModelBuilder(
    BuildContext context,
  ) =>
      CanvasitemWidgetgroupModel();
}
