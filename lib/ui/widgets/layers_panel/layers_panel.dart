import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gimelstudio/models/layer.dart';
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
          key: Key('${layer.id}'),
          onTap: () => viewModel.onSelectLayer(layer),
          child: LayerItem(
            key: Key('${layer.id}'),
            index: viewModel.layers.indexWhere((i) => layer.id == i.id),
            name: layer.name,
            isSelected: layer.selected,
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
              // Layer blend
              Expanded(
                child: Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(
                      color: Color(0xFF363636),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Normal',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.0,
                        ),
                      ),
                      PhosphorIcon(
                        PhosphorIcons.caretDown(PhosphorIconsStyle.light),
                        color: Colors.white70,
                        size: 12.0,
                      ),
                    ],
                  ),
                ),
              ),

              // Opacity
              Expanded(
                child: Container(
                  height: 30,
                  //width: 140,
                  decoration: BoxDecoration(
                    color: Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(
                      color: Color(0xFF363636),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: double.infinity,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color(0xFF363636),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '100%',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            'Opacity',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
              InkWell(
                onTap: viewModel.onAddNewLayer,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: PhosphorIcon(
                    PhosphorIcons.plus(PhosphorIconsStyle.light),
                    color: Colors.white70,
                    size: 16.0,
                  ),
                ),
              ),
              // Delete layer
              InkWell(
                onTap: viewModel.onDeleteLayer,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: PhosphorIcon(
                    PhosphorIcons.trash(PhosphorIconsStyle.light),
                    color: Colors.white70,
                    size: 16.0,
                  ),
                ),
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
