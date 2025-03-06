// Code in this file was adapted from smart_tooltip licensed
// under the MIT License. Copyright (c) 2024 Talha Attique.

import 'package:flutter/material.dart';

/// The position of the tooltip relative to the child widget.
enum TooltipPosition {
  /// Tooltip appears above the child widget.
  top,

  /// Tooltip appears below the child widget.
  bottom,

  /// Tooltip appears to the left of the child widget.
  left,

  /// Tooltip appears to the right of the child widget.
  right
}

class GsTooltipTheme {
  GsTooltipTheme({
    required this.textStyle,
    required this.keyboardShortcutTextStyle,
    required this.descriptionTextStyle,
    required this.backgroundColor,
    required this.padding,
  });

  final TextStyle textStyle;
  final TextStyle keyboardShortcutTextStyle;
  final TextStyle descriptionTextStyle;
  final Color backgroundColor;
  final double padding;
}

class GsTooltip extends StatefulWidget {
  const GsTooltip({
    super.key,
    required this.text,
    this.keyboardShortcut,
    this.description,
    this.theme,
    this.position = TooltipPosition.top,
    required this.child,
  });

  /// The main text to display.
  final String text;

  /// The keyboard shortcut to display, if any.
  final String? keyboardShortcut;

  /// The longer text description to display, if any.
  final String? description;

  /// The tooltip theme.
  final GsTooltipTheme? theme;

  /// The position of the tooltip relative to the child widget.
  ///
  /// Can be one of the following:
  /// - [TooltipPosition.top]: Displays the tooltip above the child widget.
  /// - [TooltipPosition.bottom]: Displays the tooltip below the child widget.
  /// - [TooltipPosition.left]: Displays the tooltip to the left of the child widget.
  /// - [TooltipPosition.right]: Displays the tooltip to the right of the child widget.
  /// Defaults to [TooltipPosition.top].
  final TooltipPosition position;

  /// The widget that triggers the tooltip.
  final Widget child;

  @override
  State<GsTooltip> createState() => _GsTooltipState();
}

class _GsTooltipState extends State<GsTooltip> {
  /// A key to uniquely identify the child widget and calculate its position on the screen.
  final GlobalKey _key = GlobalKey();

  /// A key to measure the tooltip dimensions.
  final GlobalKey _tooltipKey = GlobalKey();

  /// The overlay entry used to display the tooltip above other widgets.
  OverlayEntry? _overlayEntry;

  /// Tracks whether the tooltip is currently visible.
  bool _isTooltipVisible = false;

  /// The space between the tooltip and the child widget.
  double spaceBetween = 6.0;

  /// The current position of the tooltip, updated dynamically.
  late TooltipPosition currentTooltipPosition;

  /// The current widget theme.
  late GsTooltipTheme _theme;

  /// The tooltip content.
  late Widget tooltipContent;

  /// Tracks the dynamically calculated width of the tooltip.
  double tooltipWidth = 0.0;

  /// Tracks the dynamically calculated height of the tooltip.
  double tooltipHeight = 0.0;

  @override
  void initState() {
    // Set default theme.
    if (widget.theme == null) {
      _theme = GsTooltipTheme(
        textStyle: TextStyle(color: Colors.white, fontSize: 13.0, height: 1.0),
        keyboardShortcutTextStyle: TextStyle(color: Colors.white60, fontSize: 13.0, height: 1.0),
        descriptionTextStyle: TextStyle(color: Colors.white70, fontSize: 10.0, height: 1.3),
        backgroundColor: Color(0xFF1F1F1F),
        padding: 8.0,
      );
    } else {
      _theme = widget.theme!;
    }
    // Set the tooltip content.
    tooltipContent = Padding(
      padding: EdgeInsets.all(_theme.padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(TextSpan(
            children: [
              TextSpan(text: widget.text, style: _theme.textStyle),
              if (widget.keyboardShortcut != null) TextSpan(text: '   '),
              if (widget.keyboardShortcut != null)
                TextSpan(text: widget.keyboardShortcut, style: _theme.keyboardShortcutTextStyle),
              if (widget.description != null)
                TextSpan(text: '\n${widget.description}', style: _theme.descriptionTextStyle),
            ],
          ))
        ],
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    super.dispose();
  }

  void _calculateTooltipSize(VoidCallback onComplete) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Find the RenderBox of the tooltip using its global key
      final tooltipRenderBox = _tooltipKey.currentContext?.findRenderObject() as RenderBox?;

      // If the RenderBox exists, calculate the tooltip size
      if (tooltipRenderBox != null) {
        setState(() {
          tooltipWidth = tooltipRenderBox.size.width;
          tooltipHeight = tooltipRenderBox.size.height;
        });
        // Execute the callback after size calculation
        onComplete();
      }
    });
  }

  /// Displays the tooltip above the overlay.
  ///
  /// This method calculates the position and size of the tooltip relative to the child widget.
  /// It ensures the tooltip is dynamically placed within screen boundaries and adjusts its
  /// position based on available space.
  void _showTooltip() {
    // Check if the tooltip is already visible to prevent multiple insertions.
    if (_isTooltipVisible) return;

    // Get the render box of the child widget.
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // Get the render box of the overlay to calculate global positions.
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    // Calculate the global offset of the child widget relative to the overlay.
    final offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);

    // Get the size of the child widget.
    final size = renderBox.size;

    // Retrieve the screen dimensions from the overlay.
    final screenWidth = overlay.size.width;
    final screenHeight = overlay.size.height;

    // Temporarily insert a dummy tooltip off-screen to calculate its size
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: -9999, // Off-screen
        left: -9999,
        child: Material(
          color: Colors.transparent,
          child: Container(
            key: _tooltipKey, // Assign the tooltip key for size calculation
            child: tooltipContent,
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);

    // Calculate tooltip size and determine its position
    _calculateTooltipSize(() {
      // Remove the dummy tooltip after size calculation
      _overlayEntry?.remove();

      // Initialize tooltip position variables.
      double top = 0.0;
      double left = 0.0;

      // Calculate available space in each direction.
      double topSpace = offset.dy; // Space above the child widget.
      double bottomSpace = screenHeight - (offset.dy + size.height); // Space below.
      double leftSpace = offset.dx; // Space to the left of the child widget.
      double rightSpace = screenWidth - (offset.dx + size.width); // Space to the right.

      // Tooltip shape logic based on position
      switch (widget.position) {
        case TooltipPosition.top:
          if (topSpace >= tooltipHeight &&
              tooltipWidth / 2 <= offset.dx &&
              offset.dx <= screenWidth - tooltipWidth / 2) {
            top = offset.dy - tooltipHeight - spaceBetween;
            left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
          } else {
            // Not enough space at top, check left or right
            if (leftSpace >= rightSpace) {
              // Place it to the left
              left = offset.dx - tooltipWidth - spaceBetween;
              top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
              currentTooltipPosition = TooltipPosition.left;
            } else {
              // Place it to the right
              left = offset.dx + size.width + spaceBetween;
              top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
              currentTooltipPosition = TooltipPosition.right;
            }
          }
          break;
        case TooltipPosition.bottom:
          if (bottomSpace >= tooltipHeight &&
              tooltipWidth / 2 <= offset.dx &&
              offset.dx <= screenWidth - tooltipWidth / 2) {
            top = offset.dy + size.height + spaceBetween;
            left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
          } else {
            if (topSpace >= tooltipHeight &&
                tooltipWidth / 2 <= offset.dx &&
                offset.dx <= screenWidth - tooltipWidth / 2) {
              top = offset.dy - tooltipHeight - spaceBetween;
              left = offset.dx + (size.width / 2) - (tooltipWidth / 2);

              currentTooltipPosition = TooltipPosition.top;
            } else {
              // Not enough space at bottom, check left or right
              if (leftSpace >= rightSpace) {
                // Place it to the left
                left = offset.dx - tooltipWidth - spaceBetween;
                top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
                currentTooltipPosition = TooltipPosition.left;
              } else {
                // Place it to the right
                left = offset.dx + size.width + spaceBetween;
                top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
                currentTooltipPosition = TooltipPosition.right;
              }
            }
          }
          break;
        case TooltipPosition.left:
          if (leftSpace >= tooltipWidth && tooltipHeight / 2 <= bottomSpace && tooltipHeight / 2 <= topSpace) {
            top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
            left = offset.dx - tooltipWidth - spaceBetween;
          } else {
            if (rightSpace >= tooltipWidth && tooltipHeight / 2 <= bottomSpace && tooltipHeight / 2 <= topSpace) {
              left = offset.dx + size.width + spaceBetween;
              top = offset.dy + (size.height / 2) - (tooltipHeight / 2);

              currentTooltipPosition = TooltipPosition.right;
            } else {
              // Not enough space at left, check top or bottom
              if (topSpace >= bottomSpace &&
                  tooltipWidth / 2 <= offset.dx &&
                  offset.dx <= screenWidth - tooltipWidth / 2) {
                // Place it above
                left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
                top = offset.dy - tooltipHeight - spaceBetween;
                currentTooltipPosition = TooltipPosition.top;
              } else {
                if (bottomSpace >= tooltipHeight &&
                    tooltipWidth / 2 <= offset.dx &&
                    offset.dx <= screenWidth - tooltipWidth / 2) {
                  left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
                  top = offset.dy + size.height + spaceBetween;
                  currentTooltipPosition = TooltipPosition.bottom;
                } else {
                  // Not enough space at bottom, check left or right
                  if (leftSpace >= rightSpace) {
                    // Place it to the left
                    left = offset.dx - tooltipWidth - spaceBetween;
                    top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
                    currentTooltipPosition = TooltipPosition.left;
                  } else {
                    // Place it to the right
                    left = offset.dx + size.width + spaceBetween;
                    top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
                    currentTooltipPosition = TooltipPosition.right;
                  }
                }
              }
            }
          }
          break;
        case TooltipPosition.right:
          if (rightSpace >= tooltipWidth && tooltipHeight / 2 <= bottomSpace && tooltipHeight / 2 <= topSpace) {
            top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
            left = offset.dx + size.width + spaceBetween;
          } else {
            if (leftSpace >= tooltipWidth && tooltipHeight / 2 <= bottomSpace && tooltipHeight / 2 <= topSpace) {
              left = offset.dx - tooltipWidth - spaceBetween;
              top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
              currentTooltipPosition = TooltipPosition.left;
            } else {
              // Not enough space at right, check top or bottom
              if (topSpace >= bottomSpace &&
                  tooltipWidth / 2 <= offset.dx &&
                  offset.dx <= screenWidth - tooltipWidth / 2) {
                // Place it above
                left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
                top = offset.dy - tooltipHeight - spaceBetween;
                currentTooltipPosition = TooltipPosition.top;
              } else {
                // Place it below
                if (bottomSpace >= tooltipHeight &&
                    tooltipWidth / 2 <= offset.dx &&
                    offset.dx <= screenWidth - tooltipWidth / 2) {
                  left = offset.dx + (size.width / 2) - (tooltipWidth / 2);
                  top = offset.dy + size.height + spaceBetween;
                  currentTooltipPosition = TooltipPosition.bottom;
                } else {
                  // Not enough space at bottom, check left or right
                  if (leftSpace >= rightSpace) {
                    // Place it to the left
                    left = offset.dx - tooltipWidth - spaceBetween;
                    top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
                    currentTooltipPosition = TooltipPosition.left;
                  } else {
                    // Place it to the right
                    left = offset.dx + size.width + spaceBetween;
                    top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
                    currentTooltipPosition = TooltipPosition.right;
                  }
                }
              }
            }
          }
          break;
      }

      // Clamp to stay within screen bounds
      // Ensures the tooltip's position stays within the visible screen area.
      top = top.clamp(0.0, screenHeight - tooltipHeight);
      left = left.clamp(0.0, screenWidth - tooltipWidth);

      // Create an OverlayEntry to render the tooltip above other UI elements.
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: top, // Tooltip's vertical position
          left: left, // Tooltip's horizontal position
          child: TapRegion(
            onTapOutside: (event) => hideTooltip(), // This is necessary to make sure tooltips close
            child: Material(
              color: Colors.transparent, // Keeps the tooltip background transparent
              child: Container(
                decoration: BoxDecoration(
                  color: _theme.backgroundColor, // Tooltip background color
                  borderRadius: BorderRadius.circular(4.0), // Rounded corners
                ),
                width: tooltipWidth, // Width of the tooltip based on text
                height: tooltipHeight, // Height of the tooltip based on text
                child: tooltipContent,
              ),
            ),
          ),
        ),
      );

      // Insert the OverlayEntry into the Overlay stack to render the tooltip
      Overlay.of(context).insert(_overlayEntry!);

      // Update the state to indicate the tooltip is visible
      _isTooltipVisible = true;
    });
  }

  /// Hides the tooltip by removing the `OverlayEntry` from the overlay stack.
  void hideTooltip() {
    if (!_isTooltipVisible) return; // Avoid removing a non-existent tooltip

    // Remove the tooltip overlay entry
    _overlayEntry?.remove();
    _overlayEntry = null;

    // Update the state to indicate the tooltip is no longer visible
    _isTooltipVisible = false;
  }

  /// Builds the widget and manages tooltip visibility using mouse events.
  @override
  Widget build(BuildContext context) {
    // Set the initial tooltip position as provided in the widget
    currentTooltipPosition = widget.position;

    return MouseRegion(
      key: _key, // Key to uniquely identify this widget for layout purposes

      // Trigger to show the tooltip when the mouse enters the region
      onEnter: (_) => _showTooltip(),

      // Trigger to hide the tooltip when the mouse exits the region
      onExit: (_) => hideTooltip(),

      // The child widget over which the tooltip is displayed
      child: widget.child,
    );
  }
}
