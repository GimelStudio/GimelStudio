import 'package:flutter/material.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/ui/widgets/properties_panel/widgets/expose_property_btn/expose_property_btn.dart';
import 'package:stacked/stacked.dart';

import '../../../common/gs_double_input/gs_double_input.dart';
import 'double_widgetgroup_model.dart';

class DoubleWidgetgroup extends StackedView<DoubleWidgetgroupModel> {
  const DoubleWidgetgroup({
    super.key,
    required this.property,
    required this.onChangeValue,
    required this.onToggle,
  });

  final DoubleProperty property;
  final Function(DoubleProperty, double) onChangeValue;
  final Function(DoubleProperty) onToggle;

  @override
  Widget builder(
    BuildContext context,
    DoubleWidgetgroupModel viewModel,
    Widget? child,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0, left: 3.0, right: 8.0), // Avoid scrollbar
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
    );
  }

  @override
  DoubleWidgetgroupModel viewModelBuilder(
    BuildContext context,
  ) =>
      DoubleWidgetgroupModel();
}
