import 'package:flutter/material.dart';
import 'package:gimelstudio/ui/widgets/layers_panel/layers_panel.dart';
import 'package:gimelstudio/ui/widgets/tool_bar/tool_bar.dart';
import 'package:gimelstudio/ui/widgets/top_bar/top_bar.dart';
import 'package:gimelstudio/ui/widgets/node_graph_panel/node_graph_panel.dart';
import 'package:gimelstudio/ui/widgets/viewport_panel/viewport_panel.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/properties_panel/properties_panel.dart';
import 'main_viewmodel.dart';

class MainView extends StackedView<MainViewModel> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MainViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Column(
        children: [
          const TopBar(),
          Expanded(
            child: Row(
              children: [
                ToolBar(),
                Expanded(
                  child: Container(
                    color: Color(0xFF272727),
                    child: MultiSplitView(
                      axis: Axis.horizontal,
                      initialAreas: [
                        Area(
                          builder: (context, area) => MultiSplitView(
                            axis: Axis.vertical,
                            initialAreas: [
                              Area(
                                builder: (context, area) {
                                  return Container(
                                    color: Color(0xFF272727),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        const Expanded(
                                          child: ViewportPanel(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Area(
                                size: 170.0,
                                max: 250.0,
                                min: 50.0,
                                builder: (context, area) {
                                  return Column(
                                    children: [
                                      // Tabs
                                      Container(
                                        height: 30.0,
                                        color: Color(0xFF1F1F1F),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 2.0),
                                            Container(
                                              height: 24.0,
                                              width: 130.0,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF262626),
                                                borderRadius: BorderRadius.circular(6.0),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Node Editor',
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20.0),
                                                  PhosphorIcon(
                                                    PhosphorIcons.pushPin(PhosphorIconsStyle.light),
                                                    color: Colors.white60,
                                                    size: 12.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Node editor
                                      Expanded(
                                        child: NodeGraphPanel(),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Area(
                          size: 220.0,
                          max: 350.0,
                          min: 180.0,
                          builder: (context, area) {
                            return MultiSplitView(
                              axis: Axis.vertical,
                              initialAreas: [
                                Area(
                                  // size: 70.0,
                                  // max: 250.0,
                                  // min: 50.0,
                                  builder: (context, area) {
                                    return const PropertiesPanel();
                                  },
                                ),
                                Area(
                                  size: 370.0,
                                  max: 650.0,
                                  min: 150.0,
                                  builder: (context, area) {
                                    return const LayersPanel();
                                  },
                                ),
                              ],
                            );
                          },
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
    );
  }

  @override
  MainViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainViewModel();
}
