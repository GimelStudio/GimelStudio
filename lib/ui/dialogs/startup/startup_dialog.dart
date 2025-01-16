import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'startup_dialog_model.dart';

class StartupDialog extends StackedView<StartupDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const StartupDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    StartupDialogModel viewModel,
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
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/splash.jpg'),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(140, 12, 14, 15),
                      Color.fromARGB(20, 12, 14, 15),
                    ],
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(26.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Gimel Studio',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 30.0,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'v0.7.0-alpha development build',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.normal,
                          fontSize: 10.0,
                          letterSpacing: 0.8,
                          height: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // TODO: these are placeholder buttons
            Padding(
              padding: const EdgeInsets.only(top: 26.0),
              child: Row(
                spacing: 8.0,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      viewModel.onCreateNew();
                      completer(DialogResponse(confirmed: true));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF333333),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5.0,
                        children: [
                          PhosphorIcon(
                            PhosphorIcons.filePlus(PhosphorIconsStyle.light),
                            color: Colors.white,
                            size: 20.0,
                          ),
                          const Text(
                            'Create New',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      viewModel.onOpenFile();
                      completer(DialogResponse(confirmed: true));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF333333),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        spacing: 5.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PhosphorIcon(
                            PhosphorIcons.folderOpen(PhosphorIconsStyle.light),
                            color: Colors.white,
                            size: 20.0,
                          ),
                          const Text(
                            'Open File',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  StartupDialogModel viewModelBuilder(BuildContext context) => StartupDialogModel();
}
