import 'package:flutter/material.dart';
import 'package:gimelstudio/models/document.dart';
import 'package:gimelstudio/ui/widgets/common/gs_double_input/gs_double_input.dart';
import 'package:gimelstudio/ui/widgets/common/gs_flat_icon_btn/gs_flat_icon_btn.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'new_document_dialog_model.dart';

class NewDocumentDialog extends StackedView<NewDocumentDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const NewDocumentDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    NewDocumentDialogModel viewModel,
    Widget? child,
  ) {
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Color(0xFF191919),
      contentPadding: EdgeInsets.zero,
      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 500.0, maxWidth: 500.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 230.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 40.0,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'v0.7.0-alpha development build',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                          letterSpacing: 0.5,
                          height: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Row(
                spacing: 18.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // First column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Open file
                        Text(
                          'OPEN FILE',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Color(0xFFA4A4A4),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        GsFlatIconBtn(
                          label: 'Open...',
                          icon: PhosphorIcon(
                            PhosphorIcons.folderOpen(PhosphorIconsStyle.light),
                            color: Colors.white,
                            size: 18.0,
                          ),
                          onTap: () async {
                            bool success = await viewModel.onOpenFile();
                            if (success == true) {
                              completer(DialogResponse(confirmed: false));
                            }
                          },
                        ),
                        const SizedBox(height: 26.0),
                        // Recent files
                        Column(
                          spacing: 4.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'RECENT FILES',
                              style: TextStyle(
                                fontSize: 11.0,
                                color: Color(0xFFA4A4A4),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            // TODO: Implement recent files
                            const SizedBox(height: 40.0),
                            // GsFlatIconBtn(
                            //   onTap: () {},
                            //   label: 'website-design.gimel',
                            //   icon: PhosphorIcon(
                            //     PhosphorIcons.file(PhosphorIconsStyle.light),
                            //     color: Colors.white,
                            //     size: 18.0,
                            //   ),
                            // ),
                            // GsFlatIconBtn(
                            //   onTap: () {},
                            //   label: 'test.gimel',
                            //   icon: PhosphorIcon(
                            //     PhosphorIcons.file(PhosphorIconsStyle.light),
                            //     color: Colors.white,
                            //     size: 18.0,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // New document
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NEW DOCUMENT',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Color(0xFFA4A4A4),
                          ),
                        ),

                        const SizedBox(height: 6.0),

                        // New document width and height
                        Column(
                          spacing: 6.0,
                          children: [
                            GsDoubleInput(
                              label: 'W',
                              currentValue: viewModel.documentWidth,
                              minValue: 1.0,
                              maxValue: 100000.0,
                              formatter: '%fpx',
                              onChange: (value) => viewModel.onDocumentWidthChange(value),
                            ),
                            GsDoubleInput(
                              label: 'H',
                              currentValue: viewModel.documentHeight,
                              minValue: 1.0,
                              maxValue: 100000.0,
                              formatter: '%fpx',
                              onChange: (value) => viewModel.onDocumentHeightChange(value),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 10.0),
              child: Row(
                spacing: 8.0,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (request.data == true)
                    FilledButton(
                      onPressed: () => completer(DialogResponse(confirmed: false)),
                      style: ButtonStyle(
                        overlayColor: WidgetStatePropertyAll(Colors.transparent),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                        ),
                        backgroundColor: WidgetStateProperty.fromMap(<WidgetStatesConstraint, Color>{
                          WidgetState.focused: Color(0xFF3B3B3B),
                          WidgetState.pressed | WidgetState.hovered: Color(0xFF3B3B3B),
                          WidgetState.any: Color(0xFF303030),
                        }),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  FilledButton(
                    onPressed: () {
                      Document newDocument = viewModel.onCreateNewDocument();
                      completer(
                        DialogResponse(confirmed: true, data: newDocument),
                      );
                    },
                    style: ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                      ),
                      backgroundColor: WidgetStateProperty.fromMap(<WidgetStatesConstraint, Color>{
                        WidgetState.focused: Color(0xFF3B3B3B),
                        WidgetState.pressed | WidgetState.hovered: Color(0xFF3B3B3B),
                        WidgetState.any: Color(0xFF303030),
                      }),
                    ),
                    child: const Text(
                      'Create',
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
          ],
        ),
      ),
    );
  }

  @override
  NewDocumentDialogModel viewModelBuilder(BuildContext context) => NewDocumentDialogModel();
}
