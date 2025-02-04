import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/ui/widgets/properties_panel/properties_panel_model.dart';
import 'package:gimelstudio/ui/widgets/properties_panel/widgets/canvasitem_border_widgetgroup/canvasitem_border_widgetgroup.dart';
import 'package:gimelstudio/ui/widgets/properties_panel/widgets/canvasitem_fill_widgetgroup/canvasitem_fill_widgetgroup.dart';
import 'package:gimelstudio/ui/widgets/properties_panel/widgets/double_widgetgroup/double_widgetgroup.dart';
import 'package:gimelstudio/ui/widgets/properties_panel/widgets/integer_widgetgroup/integer_widgetgroup.dart';
import 'package:stacked/stacked.dart';

class PropertiesPanel extends StackedView<PropertiesPanelModel> {
  const PropertiesPanel({super.key});

  @override
  Widget builder(
    BuildContext context,
    PropertiesPanelModel viewModel,
    Widget? child,
  ) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 5.0, bottom: 5.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0), // Avoid scrollbar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: [
                          Text(
                            viewModel.selectedNode?.label.toUpperCase() ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (viewModel.selectedNode != null && viewModel.selectedNode?.isOutput == false)
                      Column(
                        children: [
                          for (Property property in viewModel.selectedNode!.properties.values)
                            Builder(
                              builder: (context) {
                                if (property.dataType == int) {
                                  return IntegerWidgetgroup(
                                    property: property as IntegerProperty,
                                    onChangeValue: viewModel.setPropertyValue,
                                    onToggle: viewModel.onTogglePropertyExposed,
                                  );
                                } else if (property.dataType == double) {
                                  return DoubleWidgetgroup(
                                    property: property as DoubleProperty,
                                    onChangeValue: viewModel.setPropertyValue,
                                    onToggle: viewModel.onTogglePropertyExposed,
                                  );
                                } else if (property.dataType == CanvasItemFill) {
                                  return CanvasitemFillWidgetgroup(
                                    property: property as CanvasItemFillProperty,
                                    onChangeValue: viewModel.setPropertyValue,
                                    onToggle: viewModel.onTogglePropertyExposed,
                                  );
                                } else if (property.dataType == CanvasItemBorder) {
                                  return CanvasitemBorderWidgetgroup(
                                    property: property as CanvasItemBorderProperty,
                                    onChangeValue: viewModel.setPropertyValue,
                                    onToggle: viewModel.onTogglePropertyExposed,
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  PropertiesPanelModel viewModelBuilder(
    BuildContext context,
  ) =>
      PropertiesPanelModel();
}
