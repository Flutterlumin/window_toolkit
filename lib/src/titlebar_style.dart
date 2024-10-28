/// Specifies different styles for the window's title bar.
///
/// The `TitlebarStyle` enum defines various styles for displaying or hiding
/// the title bar in a window. This allows developers to configure how the
/// title bar appears based on their design requirements.
///
/// Usage example:
/// ```dart
/// TitlebarStyle style = TitlebarStyle.hidden;
/// ```
enum TitlebarStyle {
  /// Completely hides the title bar from the window.
  hidden,

  /// Removes the title bar but may leave space where it would have been.
  remove,

  /// Expands the title bar to occupy more space at the top of the window.
  expand,

  /// Keeps the title bar in its default, normal appearance.
  normal,
}
