import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/ui/widgets/viewport_panel/viewport_panel_model.dart';
import 'package:stacked/stacked.dart';

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
        Paint fillPaint = Paint()
          ..color = item.fill.solidColor.withAlpha(item.opacity)
          ..style = PaintingStyle.fill
          ..blendMode = item.blendMode;

        if (item.fill.fillType == FillType.linearGradient) {
          fillPaint.shader = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: item.fill.gradientColors,
            stops: item.fill.gradientStops,
          ).createShader(item.bounds);
        } else if (item.fill.fillType == FillType.radialGradient) {
          fillPaint.shader = RadialGradient(
            colors: item.fill.gradientColors,
            stops: item.fill.gradientStops,
            focal: Alignment(item.width / 2.0, item.height / 2.0),
            focalRadius: 2.0,
          ).createShader(item.bounds);
        }

        if (item.fill.fillType != FillType.none) {
          canvas.drawRRect(
            roundedRect,
            fillPaint,
          );
        }

        // Border
        Paint borderPaint = Paint()
          ..color = item.border.fill.solidColor.withAlpha(item.opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = item.border.thickness
          ..blendMode = item.blendMode;

        if (item.border.fill.fillType == FillType.linearGradient) {
          borderPaint.shader = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: item.border.fill.gradientColors,
            stops: item.border.fill.gradientStops,
          ).createShader(item.bounds);
        } else if (item.border.fill.fillType == FillType.radialGradient) {
          borderPaint.shader = RadialGradient(
            colors: item.border.fill.gradientColors,
            stops: item.border.fill.gradientStops,
            focal: Alignment(item.width / 2.0, item.height / 2.0),
            focalRadius: 2.0,
          ).createShader(item.bounds);
        }

        if (item.border.fill.fillType != FillType.none) {
          canvas.drawRRect(
            roundedRect,
            borderPaint,
          );
        }
      } else if (item.type == 'text') {
        item = item as CanvasText;

        final paint = Paint()
          ..color = item.fill.solidColor.withAlpha(item.opacity)
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
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: item.width);

        final RRect boxRect = RRect.fromRectAndCorners(Rect.fromLTRB(0, 0, size.width, size.height));
        canvas.saveLayer(boxRect.outerRect, paint);
        textPainter.paint(canvas, Offset(item.x, item.y));
        canvas.restore();
      } else if (item.type == 'image') {
        item = item as CanvasImage;

        ui.Image? image = item.imageData;
        if (image != null) {
          // paintImage(
          //   canvas: canvas,
          //   rect: Rect.fromLTRB(item.x, item.y, item.width, item.height),
          //   image: image,
          //   fit: BoxFit.scaleDown,
          //   );
          final paint = Paint()..blendMode = item.blendMode;

          canvas.drawImage(image, Offset(item.x, item.y), paint);
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
    required this.selectedItem,
    required this.selectionOverlay,
  });

  final CanvasItem? selectedItem;
  final SelectionBoxOverlay? selectionOverlay;

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedItem != null && selectionOverlay != null) {
      CanvasItem item = selectedItem!;

      // Selection overlay
      Paint paint = Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      Rect rect = Rect.fromLTWH(
        item.bounds.left,
        item.bounds.top,
        item.bounds.width,
        item.bounds.height,
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

  double handleSize = 8.0;
  double sideHandleSize = 4.0;

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
    );
  }
}

class CanvasOverlaysWidget extends StatelessWidget {
  const CanvasOverlaysWidget({
    super.key,
    required this.selectedItem,
    required this.selectionOverlay,
  });

  final CanvasItem? selectedItem;
  final SelectionBoxOverlay? selectionOverlay;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ViewportOverlaysPainter(
        selectedItem: selectedItem,
        selectionOverlay: selectionOverlay,
      ),
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
            child: RepaintBoundary(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (event) => viewModel.onTapDown(event),
                onPanDown: (event) => viewModel.onPanDown(event),
                onPanUpdate: (event) => viewModel.onPanUpdate(event),
                onPanCancel: () => viewModel.onPanCancel(),
                onPanEnd: (event) => viewModel.onPanEnd(event),
                child: MouseRegion(
                  cursor: viewModel.mouseCursor,
                  onHover: (event) => viewModel.onHover(event),
                  child: Container(
                    width: 1920,
                    height: 1080,
                    decoration: BoxDecoration(color: Colors.white, border: Border.all()),
                    child: Stack(
                      children: [
                        CanvasWidget(items: viewModel.items),
                        CanvasOverlaysWidget(
                          selectedItem: viewModel.selectedItem,
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
      ],
    );
  }

  @override
  ViewportPanelModel viewModelBuilder(
    BuildContext context,
  ) =>
      ViewportPanelModel();
}
