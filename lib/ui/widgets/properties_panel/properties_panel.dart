import 'package:flutter/material.dart';
import 'package:gimelstudio/ui/widgets/properties_panel/properties_panel_model.dart';
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
        // Slider(
        //   min: 3.0,
        //   max: 120.0,
        //   value: viewModel.value,
        //   onChanged: (double value) {
        //     viewModel.setValue(value);
        //   },
        //   onChangeEnd: (double value) async {
        //     await viewModel.updateBlur(value.toInt(), value.toInt());
        //   },
        // ),
      ],
    );
  }

  @override
  PropertiesPanelModel viewModelBuilder(
    BuildContext context,
  ) =>
      PropertiesPanelModel();
}
