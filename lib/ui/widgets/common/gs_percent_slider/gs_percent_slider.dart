import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GsPercentSliderPainter extends CustomPainter {
  const GsPercentSliderPainter({
    required this.percent,
    required this.maxValue,
    required this.color,
  });

  final int percent;
  final int maxValue;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double value = (size.width / maxValue) * percent;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, value, size.height),
        topLeft: const Radius.circular(4.0),
        topRight: Radius.zero,
        bottomLeft: const Radius.circular(4.0),
        bottomRight: Radius.zero,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(GsPercentSliderPainter oldDelegate) => percent != oldDelegate.percent;
}

class GsPercentSliderTheme {
  GsPercentSliderTheme({
    required this.labelColor,
    required this.borderColor,
    required this.fillColor,
    required this.backgroundColor,
  });

  final Color labelColor;
  final Color borderColor;
  final Color fillColor;
  final Color backgroundColor;
}

class GsPercentSlider extends StatefulWidget {
  const GsPercentSlider({
    super.key,
    this.isEnabled = true,
    required this.label,
    required this.currentValue,
    required this.maxValue,
    required this.onChange,
    this.theme,
  });

  final bool isEnabled;
  final String label;
  final int currentValue;
  final int maxValue;

  final ValueChanged<int> onChange;

  final GsPercentSliderTheme? theme;

  @override
  State<GsPercentSlider> createState() => _GsPercentSliderState();
}

class _GsPercentSliderState extends State<GsPercentSlider> {
  /// The current widget theme.
  late GsPercentSliderTheme _theme;

  /// Initial position of the widget
  double _startPosition = 0;

  /// Initial value of the widget
  int _startValue = 0;

  /// The current mouse cursor.
  MouseCursor _mouseCursor = SystemMouseCursors.basic;

  @override
  void initState() {
    // Set default theme
    if (widget.theme == null) {
      _theme = GsPercentSliderTheme(
        labelColor: Colors.white70,
        borderColor: Color(0xFF363636),
        fillColor: Color(0xFF363636),
        backgroundColor: Color(0xFF1F1F1F),
      );
    } else {
      _theme = widget.theme!;
    }
    super.initState();
  }

  void onHover(PointerHoverEvent event) {
    setState(() {
      _mouseCursor = SystemMouseCursors.resizeUpDown;
    });
  }

  void onExitHover(PointerExitEvent event) {
    setState(() {
      _mouseCursor = SystemMouseCursors.basic;

    });
  }

  void onHorizontalDragStart(DragStartDetails event) {
    _startValue = widget.currentValue;
    _startPosition = event.globalPosition.dx;
  }

  void onHorizontalDragUpdate(DragUpdateDetails event) {
    _mouseCursor = SystemMouseCursors.resizeLeftRight;
    updateValueFromSlidePosition(_startPosition - event.globalPosition.dx);
  }

  void updateValueFromSlidePosition(double position) {
    // Should be a value between 0.1 and 1.0.
    const double speedValue = 1.0;

    // The amount per increment.
    const double increment = 1.0;

    // Calculate the next value.
    double calcValue = _startValue + (-position * speedValue);
    int newValue = (calcValue * increment).round();

    // Ensure that the result is between the accepted range.
    int clampedValue = newValue.clamp(0, widget.maxValue);

    // Pass the result to the `widget.onChange` callback.
    widget.onChange.call(clampedValue);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.isEnabled == false,
      child: Opacity(
        opacity: widget.isEnabled ? 1.0 : 0.6,
        child: MouseRegion(
          cursor: _mouseCursor,
          child: GestureDetector(
            onHorizontalDragStart: (event) => onHorizontalDragStart(event),
            onHorizontalDragUpdate: (event) => onHorizontalDragUpdate(event),
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: _theme.backgroundColor,
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  color: _theme.borderColor,
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomPaint(
                      painter: GsPercentSliderPainter(
                        percent: widget.currentValue.isNegative ? widget.maxValue : widget.currentValue,
                        maxValue: widget.maxValue,
                        color: _theme.fillColor,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.currentValue.isNegative ? '---' : '${widget.currentValue.toInt()}%',
                        style: TextStyle(
                          color: _theme.labelColor,
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
                        widget.label,
                        style: TextStyle(
                          color: _theme.labelColor,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
