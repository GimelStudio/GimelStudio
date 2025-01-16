import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'gs_integer_input_model.dart';

class GsIntegerInput extends StackedView<GsIntegerInputModel> {
  const GsIntegerInput({super.key});

  @override
  Widget builder(
    BuildContext context,
    GsIntegerInputModel viewModel,
    Widget? child,
  ) {
    return const SizedBox.shrink();
  }

  @override
  GsIntegerInputModel viewModelBuilder(
    BuildContext context,
  ) =>
      GsIntegerInputModel();
}
