import 'package:flutter/material.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/ui/widgets/common/gs_double_input/gs_double_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import 'integer_widgetgroup_model.dart';

// TODO: use IntegerInput
class IntegerWidgetgroup extends StackedView<IntegerWidgetgroupModel> {
  const IntegerWidgetgroup({
    super.key,
    required this.property,
    required this.onChangeValue,
    required this.onToggle,
  });

  final IntegerProperty property;
  final Function(IntegerProperty, int) onChangeValue;
  final Function(IntegerProperty) onToggle;

  @override
  Widget builder(
    BuildContext context,
    IntegerWidgetgroupModel viewModel,
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
                currentValue: property.value.toDouble(),
                minValue: property.min.toDouble(),
                maxValue: property.max.toDouble(),
                onChange: (value) => onChangeValue(property, value.toInt()),
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
  IntegerWidgetgroupModel viewModelBuilder(
    BuildContext context,
  ) =>
      IntegerWidgetgroupModel();
}
