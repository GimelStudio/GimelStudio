import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart';
import 'package:gimelstudio/ui/widgets/viewport_panel/viewport_panel_model.dart';
import 'package:stacked/stacked.dart';

class ViewportCanvasPainter extends CustomPainter {
  const ViewportCanvasPainter({
    required this.items,
    required this.result,
  });

  final List<Rectangle> items;
  final String result;

  @override
  void paint(Canvas canvas, Size size) {
    for (int index = 0; index < items.length; index++) {
      Rectangle item = items[index];

      Color color = Colors.deepPurple.withAlpha(item.opacity);

      if (item.type == 'rect') {
        final paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.srcOver;

        final rect = Rect.fromLTWH(
          item.x,
          item.y,
          item.width,
          item.height,
        );

        canvas.drawRect(rect, paint);
      }
    }

    if (items.isNotEmpty) {
      var item = items[0];

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

      // final TextPainter textPainter = TextPainter(
      //     text: TextSpan(text: result, style: TextStyle(color: Colors.purple, fontSize: 40.0)),
      //     textAlign: TextAlign.justify,
      //     textDirection: TextDirection.ltr)
      //   ..layout(maxWidth: size.width - 12.0 - 12.0);
      // textPainter.paint(canvas, const Offset(12.0, 36.0));
    }
  }

  @override
  bool shouldRepaint(ViewportCanvasPainter oldDelegate) => true; // TODO
}

class CanvasWidget extends StatelessWidget {
  const CanvasWidget({
    super.key,
    required this.items,
    required this.result,
  });

  final List<Rectangle> items;
  final String result;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ViewportCanvasPainter(
        items: items,
        result: result,
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
    return InteractiveViewer(
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
          onPanDown: (event) => viewModel.onPanDown(event),
          onPanUpdate: (event) => viewModel.onPanUpdate(event),
          onPanCancel: () => viewModel.onPanCancel(),
          onPanEnd: (event) => viewModel.onPanEnd(event),
          child: Container(
            width: 1920,
            height: 1080,
            decoration: BoxDecoration(color: Colors.white, border: Border.all()),
            child: CanvasWidget(items: viewModel.items, result: '${viewModel.result}'),
          ),
        ),
      ),
    );
  }

  @override
  ViewportPanelModel viewModelBuilder(
    BuildContext context,
  ) =>
      ViewportPanelModel();
}
