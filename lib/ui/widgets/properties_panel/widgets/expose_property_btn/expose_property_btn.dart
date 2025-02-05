import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import 'expose_property_btn_model.dart';

class ExposePropertyBtn extends StackedView<ExposePropertyBtnModel> {
  const ExposePropertyBtn({
    super.key,
    required this.isExposed,
    required this.onTap,
  });

  final bool isExposed;
  final Function() onTap;

  @override
  Widget builder(
    BuildContext context,
    ExposePropertyBtnModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: PhosphorIcon(
          PhosphorIcons.diamond(isExposed ? PhosphorIconsStyle.fill : PhosphorIconsStyle.light),
          color: Colors.white70,
          size: 10.0,
        ),
      ),
    );
  }

  @override
  ExposePropertyBtnModel viewModelBuilder(
    BuildContext context,
  ) =>
      ExposePropertyBtnModel();
}
