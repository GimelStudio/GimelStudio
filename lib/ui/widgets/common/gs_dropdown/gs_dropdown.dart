import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'gs_dropdown_model.dart';

class GsDropdown extends StackedView<GsDropdownModel> {
  const GsDropdown({super.key});

  @override
  Widget builder(
    BuildContext context,
    GsDropdownModel viewModel,
    Widget? child,
  ) {
    return const SizedBox.shrink();
  }

  @override
  GsDropdownModel viewModelBuilder(
    BuildContext context,
  ) =>
      GsDropdownModel();
}
