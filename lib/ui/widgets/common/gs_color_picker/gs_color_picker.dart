import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gimelstudio/models/canvas_item.dart';

class CustomDiagonalClipper extends CustomClipper<Path> {
  CustomDiagonalClipper();

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(-1.0, size.width);
    path.lineTo(size.width, -1.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class GsColorPickerTheme {
  GsColorPickerTheme({
    required this.labelColor,
    required this.borderColor,
  });

  final Color labelColor;
  final Color borderColor;
}

class GsColorPicker extends StatefulWidget {
  const GsColorPicker({
    super.key,
    required this.canvasFill,
    required this.onChange,
    this.theme,
  });

  final CanvasItemFill canvasFill;
  final ValueChanged<CanvasItemFill> onChange;

  final GsColorPickerTheme? theme;

  @override
  State<GsColorPicker> createState() => _GsColorPickerState();
}

class _GsColorPickerState extends State<GsColorPicker> {
  /// The current widget theme
  late GsColorPickerTheme _theme;

  /// The current mouse cursor.
  MouseCursor _mouseCursor = SystemMouseCursors.basic;

  /// Whether the mouse is currently hovering over the widget.
  bool _hover = false;

  @override
  void initState() {
    // Set default theme
    if (widget.theme == null) {
      _theme = GsColorPickerTheme(
        labelColor: Colors.white,
        borderColor: Color(0xFF303030),
      );
    } else {
      _theme = widget.theme!;
    }
    super.initState();
  }

  void onHover(PointerHoverEvent event) {
    setState(() {
      _hover = true;
    });
  }

  void onExitHover(PointerExitEvent event) {
    setState(() {
      _hover = false;
    });
  }

  void onHoverColorButton(PointerHoverEvent event) {
    _mouseCursor = SystemMouseCursors.click;
  }

  void onExitHoverColorButton(PointerExitEvent event) {
    _mouseCursor = SystemMouseCursors.basic;
  }

  String getColorPickerButtonLabel() {
    FillType fillType = widget.canvasFill.fillType;
    if (fillType == FillType.linearGradient) {
      return 'Linear';
    } else if (fillType == FillType.radialGradient) {
      return 'Radial';
    }
    return widget.canvasFill.solidColor.toHexString();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _mouseCursor,
      onHover: (event) => onHover(event),
      onExit: (event) => onExitHover(event),
      child: Container(
        padding: const EdgeInsets.only(top: 4.0, left: 6.0, bottom: 4.0, right: 6.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          border: Border.all(color: _hover ? _theme.borderColor : Colors.transparent),
        ),
        child: Row(
          spacing: 7.0,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                width: 22.0,
                height: 22.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: 22.0,
                      height: 22.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: Image.asset(
                            'assets/checkerboard_pattern.png',
                          ).image,
                          fit: BoxFit.cover,
                          scale: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                    if (widget.canvasFill.fillType == FillType.solid)
                      Stack(
                        children: [
                          ClipPath(
                            clipper: CustomDiagonalClipper(),
                            child: Container(
                              width: 22.0,
                              height: 22.0,
                              decoration: BoxDecoration(
                                color: widget.canvasFill.solidColor.withAlpha(255),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                            ),
                          ),
                          Container(
                            width: 22.0,
                            height: 22.0,
                            decoration: BoxDecoration(
                              color: widget.canvasFill.solidColor,
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                        ],
                      ),
                    if (widget.canvasFill.fillType == FillType.linearGradient)
                      Container(
                        width: 22.0,
                        height: 22.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: widget.canvasFill.gradientColors,
                            stops: widget.canvasFill.gradientStops,
                          ),
                        ),
                      ),
                    if (widget.canvasFill.fillType == FillType.radialGradient)
                      Container(
                        width: 22.0,
                        height: 22.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          gradient: RadialGradient(
                            colors: widget.canvasFill.gradientColors,
                            stops: widget.canvasFill.gradientStops,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Text(
                getColorPickerButtonLabel(),
                style: TextStyle(
                  fontSize: 14.0,
                  color: _theme.labelColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
