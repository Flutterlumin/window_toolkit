import 'package:window_toolkit/src/titlebar_style.dart';

/// Represents the configuration options for a window's title bar.
///
/// The `Titlebar` class allows customization of the title bar's appearance,
/// including the style of the title bar.
///
/// Usage example:
/// ```dart
/// Titlebar(titlebarStyle: TitlebarStyle.hidden)
/// ```
class Titlebar {
  /// Creates a new `Titlebar` with the specified [style].
  ///
  /// The [style] property determines the appearance of the title bar.
  const Titlebar({this.style});

  /// Defines the style of the title bar.
  ///
  /// This can be set to various styles defined in `TitlebarStyle`, such as
  /// `hidden`, `compact`, or `expanded`.
  final TitlebarStyle? style;
}
