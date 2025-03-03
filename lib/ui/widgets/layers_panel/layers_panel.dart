import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/ui/common/constants.dart';
import 'package:gimelstudio/ui/widgets/common/gs_dropdown/gs_dropdown.dart';
import 'package:gimelstudio/ui/widgets/common/gs_icon_btn/gs_icon_btn.dart';
import 'package:gimelstudio/ui/widgets/common/gs_percent_slider/gs_percent_slider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import 'layers_panel_model.dart';
import 'widgets/layer_item/layer_item.dart';

class LayersPanel extends StackedView<LayersPanelModel> {
  const LayersPanel({super.key});

  @override
  Widget builder(
    BuildContext context,
    LayersPanelModel viewModel,
    Widget? child,
  ) {
    final List<Widget> layerWidgets = [
      for (Layer layer in viewModel.layers)
        InkWell(
          key: Key(layer.id),
          onTap: () => viewModel.onSelectLayer(layer),
          child: LayerItem(
            key: Key(layer.id),
            index: layer.index,
            name: layer.name,
            isSelected: viewModel.selectedLayers.contains(layer),
            isVisible: layer.visible,
            isLocked: layer.locked,
            onToggleVisibility: () => viewModel.onToggleLayerVisibility(layer),
            onToggleLocked: () => viewModel.onToggleLayerLocked(layer),
          ),
        ),
    ];

    Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double scale = lerpDouble(1, 1.02, animValue)!;
          return Transform.scale(
            scale: scale,
            child: Material(
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              child: layerWidgets[index],
            ),
          );
        },
        child: child,
      );
    }

    return Container(
      color: Color(0xFF292929),
      width: 250.0,
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
            spacing: 5.0,
            children: [
              // Blend mode
              Expanded(
                child: GsDropdown(
                  isEnabled: viewModel.isLayerBlendModeDropdownEnabled,
                  width: 200.0,
                  currentItem: viewModel.selectedLayers.firstOrNull?.blend ?? 'Normal',
                  items: Constants.layerBlendModes.keys.toList(),
                  onChange: (value) => viewModel.onChangeLayerBlendMode(value ?? 'Normal'),
                ),
              ),
              // Opacity
              Expanded(
                child: GsPercentSlider(
                  isEnabled: viewModel.isLayerOpacitySliderEnabled,
                  label: 'Opacity',
                  currentValue: viewModel.selectedLayers.firstOrNull?.opacity ?? -1,
                  maxValue: 100,
                  onChange: (value) => viewModel.onChangeLayerOpacity(value),
                ),
              ),
            ],
          ),

          // STACK
          const SizedBox(height: 8.0),

          Expanded(
            child: viewModel.layers.isEmpty
                ? Container()
                : ReorderableListView(
                    buildDefaultDragHandles: false,
                    proxyDecorator: proxyDecorator,
                    onReorder: viewModel.onReorderLayers,
                    children: layerWidgets,
                  ),
          ),

          // Bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Add new layer
              GsIconBtn(
                isEnabled: viewModel.isAddNewLayerBtnEnabled,
                icon: PhosphorIcon(
                  PhosphorIcons.plus(PhosphorIconsStyle.light),
                  color: Colors.white70,
                  size: 16.0,
                ),
                onTap: viewModel.onAddNewLayer,
              ),
              // Delete layer
              GsIconBtn(
                isEnabled: viewModel.isDeleteLayerBtnEnabled,
                icon: PhosphorIcon(
                  PhosphorIcons.trash(PhosphorIconsStyle.light),
                  color: Colors.white70,
                  size: 16.0,
                ),
                onTap: viewModel.onDeleteLayer,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  LayersPanelModel viewModelBuilder(
    BuildContext context,
  ) =>
      LayersPanelModel();
}
