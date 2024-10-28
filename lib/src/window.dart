import 'dart:ui';

/// A configuration class for defining various properties of a window.
///
/// The `Window` class allows developers to specify different window attributes,
/// such as whether the window is movable, closable, or resizable, as well as
/// its size, opacity, and positioning options. Each property is optional and
/// can be set individually.
///
/// Example usage:
/// ```dart
/// Window windowConfig = Window(
///   movable: true,
///   closable: true,
///   opacity: 0.8,
///   size: Size(800, 600),
/// );
/// ```
class Window {
  /// Creates a new instance of [Window] with specified properties.
  const Window({
    this.movable,
    this.closable,
    this.minimizable,
    this.maximizable,
    this.center,
    this.opacity,
    this.size,
    this.minimumSize,
    this.maximumSize,
  });

  /// Determines if the window can be moved around the screen.
  final bool? movable;

  /// Determines if the window can be closed.
  final bool? closable;

  /// Determines if the window can be minimized.
  final bool? minimizable;

  /// Determines if the window can be maximized.
  final bool? maximizable;

  /// Centers the window on the screen if set to `true`.
  final bool? center;

  /// Sets the opacity of the window, where `1.0` is fully opaque and `0.0` is fully transparent.
  final double? opacity;

  /// Defines the current size of the window in logical pixels.
  final Size? size;

  /// Defines the minimum size constraints of the window.
  final Size? minimumSize;

  /// Defines the maximum size constraints of the window.
  final Size? maximumSize;
}
