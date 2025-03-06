import 'package:flutter/material.dart';
import 'package:gimelstudio/ui/common/constants.dart';
import 'package:gimelstudio/ui/widgets/common/gs_flat_icon_btn/gs_flat_icon_btn.dart';
import 'package:gimelstudio/ui/widgets/common/gs_tooltip/gs_tooltip.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'about_dialog_model.dart';

class AboutDialog extends StackedView<AboutDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const AboutDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    AboutDialogModel viewModel,
    Widget? child,
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Color(0xFF191919),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 500.0, maxWidth: 500.0, maxHeight: 300.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GsTooltip(
                  text: 'Close',
                  position: TooltipPosition.bottom,
                  child: InkWell(
                    onTap: () {
                      completer(DialogResponse(confirmed: true));
                    },
                    borderRadius: BorderRadius.circular(20.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PhosphorIcon(
                        PhosphorIcons.x(PhosphorIconsStyle.regular),
                        size: 18.0,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Main content
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Logo icon
                            Image.asset(
                              'assets/gimel-studio-icon.png',
                              width: 80.0,
                              height: 80.0,
                              isAntiAlias: true,
                              cacheHeight: 170,
                              cacheWidth: 170,
                              filterQuality: FilterQuality.medium,
                            ),
                            const SizedBox(width: 14.0),
                            // Version
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gimel Studio',
                                  style: TextStyle(
                                    height: 1.3,
                                    color: Colors.white,
                                    fontSize: 33.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.01,
                                  ),
                                ),
                                Text(
                                  'Version ${viewModel.getApplicationVersion()} ${envPlatform == '' ? '' : 'for $envPlatform'}',
                                  style: TextStyle(
                                    height: 1.0,
                                    color: Colors.white,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.01,
                                  ),
                                ),
                                // Build information
                                Text(
                                  'Built on ${viewModel.getBuildDate()} from branch $envBuildBranch, commit ${envBuildCommit == '(unknown)' ? envBuildCommit : envBuildCommit.substring(0, 7)}.',
                                  style: TextStyle(
                                    height: 2.5,
                                    color: Colors.white54,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ],
                            ),
                            // Copy version info button
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GsTooltip(
                                  text: 'Copy application info to the clipboard',
                                  position: TooltipPosition.bottom,
                                  child: InkWell(
                                    onTap: viewModel.copyInfoToClipBoard,
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        spacing: viewModel.infoCopied ? 4.0 : 0.0,
                                        children: [
                                          PhosphorIcon(
                                            PhosphorIcons.copy(PhosphorIconsStyle.regular),
                                            size: 16.0,
                                            color: Colors.white54,
                                          ),
                                          if (viewModel.infoCopied)
                                            Text(
                                              'Copied!',
                                              style: TextStyle(color: Colors.white54, fontSize: 11.0),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Buttons
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              spacing: 18.0,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // First column
                                Expanded(
                                  child: Column(
                                    spacing: 4.0,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GsFlatIconBtn(
                                        label: 'Contribute',
                                        icon: PhosphorIcon(
                                          PhosphorIcons.smiley(PhosphorIconsStyle.light),
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                        onTap: viewModel.onContribute,
                                      ),
                                      GsFlatIconBtn(
                                        label: 'Visit Website',
                                        icon: PhosphorIcon(
                                          PhosphorIcons.globeSimple(PhosphorIconsStyle.light),
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                        onTap: viewModel.onVisitWebsite,
                                      ),
                                      GsFlatIconBtn(
                                        label: 'Join Community Chat',
                                        icon: PhosphorIcon(
                                          PhosphorIcons.chats(PhosphorIconsStyle.light),
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                        onTap: viewModel.onJoinCommunityChat,
                                      ),
                                    ],
                                  ),
                                ),

                                // Second column
                                Expanded(
                                  child: Column(
                                    spacing: 4.0,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GsFlatIconBtn(
                                        label: 'Credits',
                                        icon: PhosphorIcon(
                                          PhosphorIcons.article(PhosphorIconsStyle.light),
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                        onTap: viewModel.onCredits,
                                      ),
                                      GsFlatIconBtn(
                                        label: 'Licenses',
                                        icon: PhosphorIcon(
                                          PhosphorIcons.fileText(PhosphorIconsStyle.light),
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                        onTap: viewModel.onLicenses,
                                      ),
                                    ],
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

            // Bottom text
            Text(
              'Gimel Studio is free software licensed under the terms of the GPL-3.0 license.\n© 2025 Gimel Studio contributors.',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 11.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  AboutDialogModel viewModelBuilder(BuildContext context) => AboutDialogModel();
}
