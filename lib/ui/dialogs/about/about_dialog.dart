import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'about_dialog_model.dart';

class AboutDialog extends StackedView<AboutDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const AboutDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AboutDialogModel viewModel,
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
  AboutDialogModel viewModelBuilder(BuildContext context) => AboutDialogModel();
}
