import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A macOS-style circular icon button.
///
/// The `MacosIconButton` is a customizable circular button that supports
/// macOS-like behavior with subtle animations, hover effects, and state-dependent
/// appearance changes.
///
/// This button can be used to perform actions and is particularly suited for use
/// in macOS-like UIs.
///
/// Example:
/// ```dart
/// MacosIconButton(
///   onPressed: () {
///     print("Button clicked!");
///   },
///   icon: Icon(Icons.close),
///   backgroundColor: Colors.red,
/// )
/// ```
class MacosIconButton extends StatefulWidget {
  /// Creates a macOS-style circular icon button.
  ///
  /// - [onPressed]: Callback function executed when the button is pressed.
  /// - [icon]: The icon displayed inside the button.
  /// - [backgroundColor]: The background color of the button (defaults to system fill).
  const MacosIconButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.backgroundColor,
  });

  /// The callback function triggered when the button is pressed.
  final VoidCallback? onPressed;

  /// The widget (usually an icon) displayed inside the button.
  final Widget icon;

  /// The background color of the button.
  final Color? backgroundColor;

  @override
  State<MacosIconButton> createState() => _MacosIconButtonState();
}

class _MacosIconButtonState extends State<MacosIconButton> {
  /// Tracks whether the button is currently being held down.
  bool buttonHeldDown = false;

  /// Determines the background color of the button based on its state.
  ///
  /// When the button is held down, the background color becomes slightly
  /// more transparent to give visual feedback.
  Color get _backgroundColor {
    if (buttonHeldDown) {
      return (widget.backgroundColor ?? CupertinoColors.systemFill).withOpacity(0.7);
    }
    return widget.backgroundColor ?? CupertinoColors.systemFill;
  }

  /// Handles the "tap down" event, triggered when the user presses the button.
  void _handleTapDown(TapDownDetails event) {
    setState(() => buttonHeldDown = true);
  }

  /// Handles the "tap up" event, triggered when the user releases the button.
  ///
  /// Executes the `onPressed` callback if it is not null.
  void _handleTapUp(TapUpDetails event) {
    setState(() => buttonHeldDown = false);
    if (widget.onPressed != null) widget.onPressed!();
  }

  /// Handles the "tap cancel" event, triggered when the user cancels the tap.
  ///
  /// Resets the button state to not held down.
  void _handleTapCancel() {
    setState(() => buttonHeldDown = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// Detects when the button is pressed down.
      onTapDown: widget.onPressed != null ? _handleTapDown : null,

      /// Detects when the button is released.
      onTapUp: widget.onPressed != null ? _handleTapUp : null,

      /// Detects when the button press is canceled.
      onTapCancel: widget.onPressed != null ? _handleTapCancel : null,

      child: AnimatedContainer(
        /// Specifies the size of the button.
        constraints: const BoxConstraints.tightFor(width: 12, height: 12),

        /// Adds a smooth animation when the button state changes.
        duration: const Duration(milliseconds: 100),

        /// Decorates the button with a circular shape and background color.
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(color: Colors.black.withOpacity(0.2), width: 0.5),
          shape: BoxShape.circle,
        ),

        /// Displays the provided icon inside the button.
        child: widget.icon,
      ),
    );
  }
}
