import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GsFlatIconBtn extends StatefulWidget {
  const GsFlatIconBtn({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final Function() onTap;

  @override
  State<GsFlatIconBtn> createState() => _GsFlatIconBtnState();
}

class _GsFlatIconBtnState extends State<GsFlatIconBtn> {
  /// Whether the mouse is currently hovering over the widget.
  bool _hover = false;

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
    return InkWell(
      onTap: widget.onTap,
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      child: MouseRegion(
        onHover: (event) => onHover(event),
        onExit: (event) => onExitHover(event),
        child: Container(
          padding: const EdgeInsets.only(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0),
          decoration: BoxDecoration(
            color: _hover ? Color(0xFF303030) : Colors.transparent,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            spacing: 6.0,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.icon,
              Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
