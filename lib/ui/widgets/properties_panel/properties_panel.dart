import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gimelstudio/models/canvas_item.dart' as item;
import 'package:gimelstudio/models/node_property.dart';
import 'package:gimelstudio/ui/widgets/properties_panel/properties_panel_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
                    Text(
                      viewModel.selectedNode?.label.toUpperCase() ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (viewModel.selectedNode != null && viewModel.selectedNode?.isOutput == false)
                      Column(
                        children: [
                          for (Property property in viewModel.selectedNode!.properties.values)
                            Builder(
                              builder: (context) {
                                if (property.dataType == int) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${property.label} (${property.value})',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13.0,
                                        ),
                                      ),
                                      Expanded(
                                        child: Visibility(
                                          visible: property.isExposed == false,
                                          maintainSize: true,
                                          maintainAnimation: true,
                                          maintainState: true,
                                          child: Slider(
                                            min: 0.0,
                                            max: 500.0,
                                            value: property.value.toDouble(),
                                            onChanged: (double value) =>
                                                viewModel.setPropertyValue(property, value.toInt()),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        // TODO: eventually this will be a menu with the option to reset to the default value as well.
                                        onTap: () => viewModel.onTogglePropertyExposed(property),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: PhosphorIcon(
                                            PhosphorIcons.diamond(property.isExposed
                                                ? PhosphorIconsStyle.fill
                                                : PhosphorIconsStyle.light),
                                            color: Colors.white70,
                                            size: 10.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (property.dataType == item.CanvasItemFill) {
                                  item.CanvasItemFill val = property.value as item.CanvasItemFill;
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: HueRingPicker(
                                          pickerColor: val.solidColor,
                                          onColorChanged: (Color color) {
                                            var c =
                                                item.CanvasItemFill(fillType: item.FillType.solid, solidColor: color);
                                            viewModel.setPropertyValue(property, c);
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                        ],
                      ),

                    // DropdownButton<String>(
                    //   // Step 3.
                    //   value: 'Dog',
                    //   // Step 4.
                    //   items: <String>['Dog', 'Cat', 'Tiger', 'Lion'].map<DropdownMenuItem<String>>((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(
                    //         value,
                    //         style: const TextStyle(
                    //           fontSize: 30.0,
                    //         ),
                    //       ),
                    //     );
                    //   }).toList(),
                    //   // Step 5.
                    //   onChanged: (String? newValue) {
                    //     // setState(() {
                    //     //   dropdownValue = newValue!;
                    //     // });
                    //   },
                    // ),
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
