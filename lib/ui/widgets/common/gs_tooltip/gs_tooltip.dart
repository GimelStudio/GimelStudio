import 'package:flutter/material.dart';

class GsTooltip extends StatelessWidget {
  const GsTooltip({
    super.key,
    required this.text,
    this.description,
    this.keyboardShortcut,
    required this.child,
  });

  final String text;
  final String? description;
  final String? keyboardShortcut;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      exitDuration: Duration(milliseconds: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Color(0xFF1F1F1F),
      ),
      richMessage: TextSpan(
        children: [
          TextSpan(text: text, style: TextStyle(color: Colors.white)),
          if (keyboardShortcut != null) TextSpan(text: '   '),
          if (keyboardShortcut != null) TextSpan(text: keyboardShortcut, style: TextStyle(color: Colors.white60)),
          if (description != null)
            TextSpan(text: '\n$description', style: TextStyle(color: Colors.white70, fontSize: 10.0)),
        ],
      ),
      child: child,
    );
  }
}
