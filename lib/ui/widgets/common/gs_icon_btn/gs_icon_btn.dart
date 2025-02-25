import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GsIconBtnTheme {
  GsIconBtnTheme({
    required this.selectedColor,
  });

  final Color selectedColor;
}

/// Icon button.
class GsIconBtn extends StatefulWidget {
  const GsIconBtn({
    super.key,
    this.isEnabled = true,
    required this.icon,
    this.selected = false,
    required this.onTap,
    this.theme,
  });

  final bool isEnabled;
  final Widget icon;
  final bool selected;
  final Function() onTap;
  final GsIconBtnTheme? theme;

  @override
  State<GsIconBtn> createState() => _GsIconBtnState();
}

class _GsIconBtnState extends State<GsIconBtn> {
  /// The current widget theme
  late GsIconBtnTheme _theme;

  /// Whether the mouse is currently hovering over the widget.
  bool _hover = false;

  @override
  void initState() {
    // Set default theme
    if (widget.theme == null) {
      _theme = GsIconBtnTheme(
        selectedColor: Color(0xFF303030),
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

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.isEnabled == false,
      child: Opacity(
        opacity: widget.isEnabled ? 1.0 : 0.6,
        child: InkWell(
          onTap: widget.onTap,
          child: MouseRegion(
            onHover: (event) => onHover(event),
            onExit: (event) => onExitHover(event),
            child: Container(
              decoration: BoxDecoration(
                color: _hover || widget.selected ? _theme.selectedColor : Colors.transparent,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(6.0),
              child: widget.icon,
            ),
          ),
        ),
      ),
    );
  }
}
