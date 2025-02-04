import 'package:flutter/material.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
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
  DoubleWidgetgroupModel viewModelBuilder(
    BuildContext context,
  ) =>
      DoubleWidgetgroupModel();
}
