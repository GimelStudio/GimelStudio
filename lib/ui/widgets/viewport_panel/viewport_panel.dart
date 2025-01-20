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

      if (item.type == 'rect') {
        item = item as CanvasRectangle;

        final paint = Paint()
          ..color = item.fill.solidColor.withAlpha(item.opacity)
          ..style = PaintingStyle.fill
          ..blendMode = item.blendMode;

        final rect = Rect.fromLTWH(
          item.x,
          item.y,
          item.width,
          item.height,
        );

        //canvas.drawRect(rect, paint);

        canvas.drawRRect(
          RRect.fromRectAndCorners(
            rect,
            topLeft: Radius.zero,
            topRight: Radius.circular(60),
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero,
          ),
          paint,
        );
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

    if (items.isNotEmpty && false == true) {
      var item = items[0];
      item = item as CanvasRectangle;

      // Selection overlay
      var paint = Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      var rect = Rect.fromLTWH(
        item.x,
        item.y,
        item.width,
        item.height,
      );

      canvas.drawRect(rect, paint);

      const handleSize = 8.0;

      // Top-left
      rect = Rect.fromLTWH(
        item.x - (handleSize / 2.0),
        item.y - (handleSize / 2.0),
        handleSize,
        handleSize,
      );

      paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRect(rect, paint);

      paint = Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawRect(rect, paint);

      // Bottom-left
      rect = Rect.fromLTWH(
        item.x - (handleSize / 2.0),
        item.y + (item.height - (handleSize / 2.0)),
        handleSize,
        handleSize,
      );

      paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRect(rect, paint);

      paint = Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawRect(rect, paint);

      // Top-right
      rect = Rect.fromLTWH(
        item.x + (item.width - (handleSize / 2.0)),
        item.y - (handleSize / 2.0),
        handleSize,
        handleSize,
      );

      paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRect(rect, paint);

      paint = Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawRect(rect, paint);

      // Bottom-right
      rect = Rect.fromLTWH(
        item.x + (item.width - (handleSize / 2.0)),
        item.y + (item.height - (handleSize / 2.0)),
        handleSize,
        handleSize,
      );

      paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRect(rect, paint);

      paint = Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(ViewportCanvasPainter oldDelegate) => true; // TODO
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
                behavior: HitTestBehavior.translucent,
                onPanDown: (event) => viewModel.onPanDown(event),
                onPanUpdate: (event) => viewModel.onPanUpdate(event),
                onPanCancel: () => viewModel.onPanCancel(),
                onPanEnd: (event) => viewModel.onPanEnd(event),
                child: Container(
                  width: 1920,
                  height: 1080,
                  decoration: BoxDecoration(color: Colors.white, border: Border.all()),
                  child: CanvasWidget(items: viewModel.items),
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
