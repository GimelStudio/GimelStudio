import 'package:flutter/material.dart';
import 'package:gimelstudio/ui/widgets/viewport_panel/viewport_panel_model.dart';
import 'package:stacked/stacked.dart';

class ViewportPanel extends StackedView<ViewportPanelModel> {
  const ViewportPanel({super.key});

  @override
  Widget builder(
    BuildContext context,
    ViewportPanelModel viewModel,
    Widget? child,
  ) {
    return InteractiveViewer(
      minScale: 0.4,
      maxScale: 5.0,
      onInteractionStart: (ScaleStartDetails details) {
        print('Interaction started: $details');
      },
      onInteractionEnd: (ScaleEndDetails details) {
        print('Interaction ended: $details');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 800,
            height: 500,
            margin: const EdgeInsets.only(top: 12.0, bottom: 12.0),
            decoration: BoxDecoration(color: Colors.white, border: Border.all()),
            child: Row(
              children: [
                Image.asset(
                  'assets/birch-tree.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  ViewportPanelModel viewModelBuilder(
    BuildContext context,
  ) =>
      ViewportPanelModel();
}
