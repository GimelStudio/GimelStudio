import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'preferences_dialog_model.dart';

class PreferencesDialog extends StackedView<PreferencesDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const PreferencesDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PreferencesDialogModel viewModel,
    Widget? child,
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: Color(0xFF191919),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 400.0, maxWidth: 400.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                completer(DialogResponse(confirmed: true));
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  PreferencesDialogModel viewModelBuilder(BuildContext context) => PreferencesDialogModel();
}
