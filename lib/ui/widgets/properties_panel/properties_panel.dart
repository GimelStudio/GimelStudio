import 'package:flutter/material.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('${viewModel.selectedNode?.idname}', style: TextStyle(color: Colors.white)),

                  if (viewModel.selectedNode != null)
                    Column(
                      children: [
                        for (Property property in viewModel.selectedNode!.properties.values)
                          if (property.dataType == int)
                            Row(
                              children: [
                                Text(
                                  '${property.idname}: (${property.value})',
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                                Expanded(
                                  child: Slider(
                                    min: 1.0,
                                    max: 120.0,
                                    value: property.value.toDouble(),
                                    onChanged: (double value) => viewModel.setPropertyValue(property, value.toInt()),
                                  ),
                                ),
                                InkWell(
                                  // TODO: eventually this will be a menu with the option to reset to the default value as well.
                                  onTap: () => viewModel.onTogglePropertyExposed(property),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: PhosphorIcon(
                                      PhosphorIcons.diamond(
                                          property.isExposed ? PhosphorIconsStyle.fill : PhosphorIconsStyle.light),
                                      color: Colors.white70,
                                      size: 10.0,
                                    ),
                                  ),
                                ),
                              ],
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
      ],
    );
  }

  @override
  PropertiesPanelModel viewModelBuilder(
    BuildContext context,
  ) =>
      PropertiesPanelModel();
}
