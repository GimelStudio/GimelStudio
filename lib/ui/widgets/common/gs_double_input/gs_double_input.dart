import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

class GsDoubleInputTheme {
  GsDoubleInputTheme({
    required this.valueColor,
    required this.labelColor,
    required this.borderColor,
    required this.cursorColor,
  });

  final Color valueColor;
  final Color labelColor;
  final Color borderColor;
  final Color cursorColor;
}

// TODO: the mouse cursor should stay the same during the drag event.

/// A numeric field where the user can either click and drag vertically
/// to increment/de-increment the value, or type a value directly.
/// Basic math expressions are supported when a value is input directly.
class GsDoubleInput extends StatefulWidget {
  const GsDoubleInput({
    super.key,
    this.isEnabled = true,
    this.isSubwidget = false,
    this.label,
    this.startIcon,
    this.endIcon,
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
    this.increment = 1.0,
    this.formatter,
    required this.onChange,
    this.theme,
  });

  final bool isEnabled;

  /// Whether this GsDoubleInput is part of another widget.
  /// Setting this to true will disable the widget border.
  final bool isSubwidget;

  final String? label;
  final Widget? startIcon;
  final Widget? endIcon;
  final double currentValue;
  final double minValue;
  final double maxValue;
  final double increment;

  /// A formatter for adding a prefix or suffix to the value.
  /// For example, a formatter of '%f%' will format a value of
  /// 10 as '10%' and a formatter of '%fMB' with result in '10MB'.
  final String? formatter;

  final ValueChanged<double> onChange;

  final GsDoubleInputTheme? theme;

  @override
  State<GsDoubleInput> createState() => _GsDoubleInputState();
}

class _GsDoubleInputState extends State<GsDoubleInput> {
  /// Controller for managing the text input in the widget.
  final TextEditingController _textController = TextEditingController();

  /// Focus node for handling focus in the widget.
  final FocusNode _focusNode = FocusNode();

  /// The current widget theme
  late GsDoubleInputTheme _theme;

  /// Initial position of the widget
  double _startPosition = 0;

  /// Initial value of the widget
  double _startValue = 0;

  /// Whether the widget is currently in text-editing mode.
  bool _isEditingText = false;

  /// The current mouse cursor.
  MouseCursor _mouseCursor = SystemMouseCursors.basic;

  /// Whether the mouse is currently hovering over the widget.
  bool _hover = false;

  @override
  void initState() {
    // Set default theme
    if (widget.theme == null) {
      _theme = GsDoubleInputTheme(
        valueColor: Colors.white,
        labelColor: Colors.white54,
        borderColor: Color(0xFF303030),
        cursorColor: Colors.white,
      );
    } else {
      _theme = widget.theme!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void onHover(PointerHoverEvent event) {
    setState(() {
      _hover = true;
      _mouseCursor = SystemMouseCursors.resizeUpDown;
    });
  }

  void onExitHover(PointerExitEvent event) {
    setState(() {
      _hover = false;
    });
  }

  void onTapOutside(PointerDownEvent event) {
    setState(() {
      _isEditingText = false;
    });
  }

  void onTap() {
    setState(() {
      _isEditingText = true;
      _textController.text = getValueText(widget.currentValue);
    });
    _focusNode.requestFocus();
  }

  void onVerticalDragStart(DragStartDetails event) {
    _startValue = widget.currentValue;
    _startPosition = event.globalPosition.dy;
  }

  void onVerticalDragUpdate(DragUpdateDetails event) {
    _mouseCursor = SystemMouseCursors.resizeUpDown;
    updateValueFromSlidePosition(_startPosition - event.globalPosition.dy);
  }

  void onSubmitTextFieldValue(String text) {
    // Evaluate any math expressions from the input.
    double value = 0.0;
    try {
      ExpressionParser parser = GrammarParser();
      Expression expression = parser.parse(text);

      var evaluator = RealEvaluator(ContextModel());
      dynamic evalValue = evaluator.evaluate(expression);

      if (evalValue is double) {
        value = evalValue;
      } else {
        bool isInteger = int.tryParse(evalValue.toString()) != null;
        if (isInteger) {
          value = evalValue.toDouble();
        }
      }
    } catch (e) {
      // Pass: likely an invalid expression.
    }

    // Ensure that the result is between the accepted range.
    double clampedValue = clampDouble(value, widget.minValue, widget.maxValue);

    // Pass the result to the `widget.onChange` callback.
    widget.onChange.call(clampedValue);

    setState(() {
      _isEditingText = false;
    });
  }

  void updateValueFromSlidePosition(double position) {
    // If editing the text, pass.
    if (_isEditingText) {
      return;
    }

    // Should be a value between 0.1 and 1.0.
    const double speedValue = 1.0;

    // Calculate the next value.
    double calcValue = _startValue + (position * speedValue);
    double dividedValue = calcValue / widget.increment;
    int roundedValue = dividedValue.round();
    double newValue = (roundedValue * widget.increment).roundToDouble();

    // Ensure that the result is between the accepted range.
    double clampedValue = clampDouble(newValue, widget.minValue, widget.maxValue);

    // Pass the result to the `widget.onChange` callback.
    widget.onChange.call(clampedValue);
  }

  String getValueText(double value) {
    String baseValue = value.toStringAsFixed(2);
    // Don't show the trailing zeros.
    if (baseValue.endsWith('.00')) {
      baseValue = baseValue.substring(0, baseValue.length - 3);
    } else if (baseValue.endsWith('.0')) {
      baseValue = baseValue.substring(0, baseValue.length - 2);
    }
    return widget.formatter == null ? baseValue : widget.formatter!.replaceFirst(RegExp(r'%f'), baseValue);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.isEnabled == false,
      child: Opacity(
        opacity: widget.isEnabled ? 1.0 : 0.6,
        child: MouseRegion(
          cursor: _mouseCursor,
          onHover: (event) => onHover(event),
          onExit: (event) => onExitHover(event),
          child: TapRegion(
            onTapOutside: (event) => onTapOutside(event),
            child: GestureDetector(
              onTap: _isEditingText ? null : () => onTap(),
              onVerticalDragStart: (event) => onVerticalDragStart(event),
              onVerticalDragUpdate: (event) => onVerticalDragUpdate(event),
              child: Container(
                padding:
                    widget.isSubwidget ? null : const EdgeInsets.only(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(
                    color: (_hover && !widget.isSubwidget) || (_isEditingText && !widget.isSubwidget)
                        ? _theme.borderColor
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.label != null)
                      Text(
                        widget.label!,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: _theme.labelColor,
                        ),
                      ),
                    widget.startIcon != null ? widget.startIcon! : const SizedBox(),
                    _isEditingText
                        ? Expanded(
                            child: Padding(
                              padding: widget.isSubwidget
                                  ? const EdgeInsets.only(left: 3.0)
                                  : const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 3.0),
                              child: TextField(
                                controller: _textController,
                                focusNode: _focusNode,
                                style: TextStyle(
                                  color: _theme.valueColor,
                                  height: 1.0,
                                  fontSize: 14.0,
                                ),
                                cursorColor: _theme.cursorColor,
                                cursorHeight: 14.0,
                                decoration: null,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp('[0-9*/+-.()]')),
                                ],
                                onSubmitted: (value) => onSubmitTextFieldValue(value),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: widget.isSubwidget
                                  ? const EdgeInsets.only()
                                  : const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                      child: Text(
                                        getValueText(widget.currentValue),
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          height: 1.0,
                                          color: _theme.valueColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    widget.endIcon != null ? widget.endIcon! : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
