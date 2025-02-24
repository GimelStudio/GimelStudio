import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/models/layer.dart';
import 'package:gimelstudio/ui/widgets/viewport_panel/viewport_panel_model.dart';
import 'package:stacked/stacked.dart';

// TODO: these should be moved to their own files.
class ViewportCanvasPainter extends CustomPainter {
  const ViewportCanvasPainter({
    required this.items,
  });

  final List<CanvasItem> items;

  @override
  void paint(Canvas canvas, Size size) {
    for (int index = 0; index < items.length; index++) {
      CanvasItem item = items[index];

      if (item.type == 'rectangle') {
        item = item as CanvasRectangle;

        final Rect rect = Rect.fromLTWH(
          item.x,
          item.y,
          item.width,
          item.height,
        );

        final RRect roundedRect = RRect.fromRectAndCorners(
          rect,
          topLeft: Radius.circular(item.borderRadius.cornerRadi.$1),
          topRight: Radius.circular(item.borderRadius.cornerRadi.$2),
          bottomLeft: Radius.circular(item.borderRadius.cornerRadi.$3),
          bottomRight: Radius.circular(item.borderRadius.cornerRadi.$4),
        );

        // Fill
        final FillType fillType = item.fill.fillType;
        final List<Color> fillGradientColors = item.fill.gradientColors;
        final List<double> fillGradientStops = item.fill.gradientStops;

        Paint fillPaint = Paint()
          ..color = item.fill.solidColor.withAlpha(item.opacity)
          ..style = PaintingStyle.fill
          ..blendMode = item.blendMode;

        if (fillType == FillType.linearGradient) {
          fillPaint.shader = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: fillGradientColors,
            stops: fillGradientStops,
          ).createShader(item.bounds);
        } else if (fillType == FillType.radialGradient) {
          fillPaint.shader = RadialGradient(
            colors: fillGradientColors,
            stops: fillGradientStops,
            focal: Alignment(item.width / 2.0, item.height / 2.0),
            focalRadius: 2.0,
          ).createShader(item.bounds);
        }

        if (fillType != FillType.none) {
          canvas.drawRRect(
            roundedRect,
            fillPaint,
          );
        }

        // Border
        final FillType borderFillType = item.border.fill.fillType;
        final double borderThickness = item.border.thickness;
        final List<Color> borderGradientColors = item.border.fill.gradientColors;
        final List<double> borderGradientStops = item.border.fill.gradientStops;

        Paint borderPaint = Paint()
          ..color = item.border.fill.solidColor.withAlpha(item.opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderThickness
          ..blendMode = item.blendMode;

        if (borderFillType == FillType.linearGradient) {
          borderPaint.shader = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: borderGradientColors,
            stops: borderGradientStops,
          ).createShader(item.bounds);
        } else if (borderFillType == FillType.radialGradient) {
          borderPaint.shader = RadialGradient(
            colors: borderGradientColors,
            stops: borderGradientStops,
            focal: Alignment(item.width / 2.0, item.height / 2.0),
            focalRadius: 2.0,
          ).createShader(item.bounds);
        }

        if (borderFillType != FillType.none && borderThickness != 0.0) {
          canvas.drawRRect(
            roundedRect,
            borderPaint,
          );
        }
      } else if (item.type == 'text') {
        item = item as CanvasText;

        // Fill
        Paint fillPaint = Paint()
          ..color = item.fill.solidColor.withAlpha(item.opacity)
          ..style = PaintingStyle.fill
          ..blendMode = item.blendMode;

        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: item.text,
            style: TextStyle(
              color: item.fill.solidColor.withAlpha(item.opacity),
              fontSize: item.size,
              letterSpacing: item.letterSpacing,
            ),
          ),
          strutStyle: const StrutStyle(
            leading: null,
          ),
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: item.width);

        final RRect boxRect = RRect.fromRectAndCorners(Rect.fromLTRB(0, 0, size.width, size.height));
        canvas.saveLayer(boxRect.outerRect, fillPaint);
        canvas.clipRect(item.bounds);
        textPainter.paint(canvas, Offset(item.x, item.y));
        canvas.restore();
      } else if (item.type == 'image') {
        item = item as CanvasImage;

        ui.Image? image = item.imageData;

        if (image != null) {
          paintImage(
            canvas: canvas,
            rect: item.bounds, // Rect.fromLTRB(item.x, item.y, item.width, item.height),
            image: image,
            fit: BoxFit.cover,
          );
          //final paint = Paint()..blendMode = item.blendMode;
          //canvas.drawImage(image, Offset(item.x, item.y), paint);
        }
      } else if (item.type == 'oval') {
        item = item as CanvasOval;

        final paint = Paint()
          ..color = item.fill.solidColor.withAlpha(item.opacity)
          ..blendMode = item.blendMode;

        canvas.drawOval(Rect.fromLTWH(item.x, item.y, item.width, item.height), paint);
      }
    }
  }

  @override
  bool shouldRepaint(ViewportCanvasPainter oldDelegate) => true; // TODO
}

class ViewportOverlaysPainter extends CustomPainter {
  const ViewportOverlaysPainter({
    required this.selectedLayers,
    required this.selectionOverlay,
  });

  final List<Layer> selectedLayers;
  final SelectionBoxOverlay? selectionOverlay;

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedLayers.isNotEmpty && selectionOverlay != null) {
      Rect bounds;
      if (selectedLayers.length == 1) {
        bounds = selectedLayers.first.value.bounds;
      } else {
        // Use the calculated min bounds of the selected items.
        bounds = selectionOverlay!.itemBounds;
      }

      // Selection overlay
      Paint paint = Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      Rect rect = Rect.fromLTWH(
        bounds.left,
        bounds.top,
        bounds.width,
        bounds.height,
      );

      canvas.drawRect(rect, paint);

      for (SelectionOverlayHandle handle in selectionOverlay!.cornerHandles) {
        paint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

        RRect handleRRect = RRect.fromRectAndRadius(handle.handleBounds, const Radius.circular(1.0));

        canvas.drawRRect(handleRRect, paint);

        paint = Paint()
          ..color = Colors.blueAccent
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

        canvas.drawRRect(handleRRect, paint);
      }

      // For testing invisible handles
      // for (SelectionOverlayHandle handle in selectionOverlay!.sideHandles) {
      //   paint = Paint()
      //     ..color = Colors.transparent
      //     ..style = PaintingStyle.fill;

      //   canvas.drawRect(handle.handleBounds, paint);

      //   paint = Paint()
      //     ..color = Colors.red
      //     ..strokeWidth = 1.0
      //     ..style = PaintingStyle.stroke;

      //   canvas.drawRect(handle.handleBounds, paint);
      // }
    }
  }

  @override
  bool shouldRepaint(ViewportOverlaysPainter oldDelegate) => true; // TODO
}

enum SelectionOverlayHandleSide {
  top,
  topLeft,
  left,
  topRight,
  bottom,
  bottomLeft,
  right,
  bottomRight,
}

class SelectionOverlayHandle {
  SelectionOverlayHandle({
    required this.side,
    required this.itemBounds,
  });

  double handleSize = 16.0;
  double sideHandleSize = 8.0;

  final SelectionOverlayHandleSide side;
  Rect itemBounds;

  Rect get handleBounds {
    switch (side) {
      case SelectionOverlayHandleSide.top:
        return Rect.fromLTWH(
          itemBounds.left + (handleSize / 2.0),
          itemBounds.top - (sideHandleSize / 2.0),
          itemBounds.width - handleSize,
          sideHandleSize,
        );
      case SelectionOverlayHandleSide.topLeft:
        return Rect.fromLTWH(
          itemBounds.left - (handleSize / 2.0),
          itemBounds.top - (handleSize / 2.0),
          handleSize,
          handleSize,
        );
      case SelectionOverlayHandleSide.left:
        return Rect.fromLTWH(
          itemBounds.left - (sideHandleSize / 2.0),
          itemBounds.top + (handleSize / 2.0),
          sideHandleSize,
          itemBounds.height - handleSize,
        );
      case SelectionOverlayHandleSide.bottomLeft:
        return Rect.fromLTWH(
          itemBounds.left - (handleSize / 2.0),
          itemBounds.top + (itemBounds.height - (handleSize / 2.0)),
          handleSize,
          handleSize,
        );
      case SelectionOverlayHandleSide.bottom:
        return Rect.fromLTWH(
          itemBounds.left + (handleSize / 2.0),
          itemBounds.top + itemBounds.height - (sideHandleSize / 2.0),
          itemBounds.width - handleSize,
          sideHandleSize,
        );
      case SelectionOverlayHandleSide.topRight:
        return Rect.fromLTWH(
          itemBounds.left + (itemBounds.width - (handleSize / 2.0)),
          itemBounds.top - (handleSize / 2.0),
          handleSize,
          handleSize,
        );
      case SelectionOverlayHandleSide.right:
        return Rect.fromLTWH(
          itemBounds.left + itemBounds.width - (sideHandleSize / 2.0),
          itemBounds.top + (handleSize / 2.0),
          sideHandleSize,
          itemBounds.height - handleSize,
        );
      case SelectionOverlayHandleSide.bottomRight:
        return Rect.fromLTWH(
          itemBounds.left + (itemBounds.width - (handleSize / 2.0)),
          itemBounds.top + (itemBounds.height - (handleSize / 2.0)),
          handleSize,
          handleSize,
        );
    }
  }

  bool isInside(Offset point) {
    return handleBounds.contains(point);
  }
}

class SelectionBoxOverlay {
  SelectionBoxOverlay({
    required this.itemBounds,
  });

  Rect itemBounds;

  List<SelectionOverlayHandle> get sideHandles => [
        SelectionOverlayHandle(side: SelectionOverlayHandleSide.top, itemBounds: itemBounds),
        SelectionOverlayHandle(side: SelectionOverlayHandleSide.left, itemBounds: itemBounds),
        SelectionOverlayHandle(side: SelectionOverlayHandleSide.bottom, itemBounds: itemBounds),
        SelectionOverlayHandle(side: SelectionOverlayHandleSide.right, itemBounds: itemBounds),
      ];

  List<SelectionOverlayHandle> get cornerHandles => [
        SelectionOverlayHandle(side: SelectionOverlayHandleSide.topLeft, itemBounds: itemBounds),
        SelectionOverlayHandle(side: SelectionOverlayHandleSide.bottomLeft, itemBounds: itemBounds),
        SelectionOverlayHandle(side: SelectionOverlayHandleSide.topRight, itemBounds: itemBounds),
        SelectionOverlayHandle(side: SelectionOverlayHandleSide.bottomRight, itemBounds: itemBounds),
      ];

  SelectionOverlayHandleSide? getHandle(Offset point) {
    for (SelectionOverlayHandle handle in [...cornerHandles, ...sideHandles]) {
      if (handle.isInside(point)) {
        return handle.side;
      }
    }
    return null;
  }
}

class CanvasWidget extends StatelessWidget {
  const CanvasWidget({
    super.key,
    required this.items,
  });

  final List<CanvasItem> items;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ViewportCanvasPainter(
        items: items,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class CanvasOverlaysWidget extends StatelessWidget {
  const CanvasOverlaysWidget({
    super.key,
    required this.selectedLayers,
    required this.selectionOverlay,
  });

  final List<Layer> selectedLayers;
  final SelectionBoxOverlay? selectionOverlay;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ViewportOverlaysPainter(
        selectedLayers: selectedLayers,
        selectionOverlay: selectionOverlay,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class ViewportPanel extends StackedView<ViewportPanelModel> {
  const ViewportPanel({super.key});

  @override
  Widget builder(
    BuildContext context,
    ViewportPanelModel viewModel,
    Widget? child,
  ) {
    return Row(
      children: [
        Expanded(
          child: InteractiveViewer(
            minScale: 0.01,
            maxScale: 5.0,
            onInteractionStart: (ScaleStartDetails details) {
              print('Interaction started: $details');
            },
            onInteractionEnd: (ScaleEndDetails details) {
              print('Interaction ended: $details');
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FittedBox(
                child: RepaintBoundary(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (event) => viewModel.toolModeHandler.onTapDown(event),
                    onPanDown: (event) => viewModel.toolModeHandler.onPanDown(event),
                    onPanUpdate: (event) => viewModel.toolModeHandler.onPanUpdate(event),
                    onPanCancel: () => viewModel.toolModeHandler.onPanCancel(),
                    onPanEnd: (event) => viewModel.toolModeHandler.onPanEnd(event),
                    child: MouseRegion(
                      cursor: viewModel.mouseCursor,
                      onHover: (event) => viewModel.toolModeHandler.onHover(event),
                      child: Container(
                        width: viewModel.activeDocument?.size.width,
                        height: viewModel.activeDocument?.size.height,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: Stack(
                          children: [
                            ClipRect(child: CanvasWidget(items: viewModel.items)),
                            CanvasOverlaysWidget(
                              selectedLayers: viewModel.selectedLayers,
                              selectionOverlay: viewModel.selectionOverlay,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  ViewportPanelModel viewModelBuilder(
    BuildContext context,
  ) =>
      ViewportPanelModel();
}
