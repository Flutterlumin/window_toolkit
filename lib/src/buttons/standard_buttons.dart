import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:window_toolkit/src/buttons/macos_icon_button.dart';
import 'package:window_toolkit/src/window_listener.dart';
import 'package:window_toolkit/window_toolkit.dart';

/// A widget that provides standard window control buttons for macOS apps.
///
/// The `StandardButtons` widget includes close, minimize, and maximize buttons,
/// and dynamically updates their appearance and behavior based on window states
/// such as focus, hover, and maximization.
///
/// This widget uses the `WindowToolkit` to interact with window states and
/// perform actions such as minimizing, maximizing, and closing the window.
class StandardButtons extends StatefulWidget {
  /// Creates a `StandardButtons` widget.
  const StandardButtons({super.key});

  @override
  State<StandardButtons> createState() => _StandardButtonsState();
}

class _StandardButtonsState extends State<StandardButtons> with WindowListener {
  /// Instance of `WindowToolkit` to interact with the macOS window.
  late WindowToolkit toolkit;

  /// Indicates whether the mouse is hovering over the button area.
  bool hovering = false;

  /// Indicates whether the window is currently focused.
  bool focused = true;

  /// Indicates whether the window is maximized or in fullscreen mode.
  bool maximized = false;

  @override
  void initState() {
    super.initState();

    /// Initialize the `WindowToolkit` and add this widget as a listener
    /// for window state changes.
    toolkit = WindowToolkit.instance;
    toolkit.addListener(this);
  }

  /// Called when the window gains focus.
  @override
  void onWindowFocus() {
    setState(() => focused = true);
  }

  /// Called when the window loses focus.
  @override
  void onWindowBlur() {
    setState(() => focused = false);
  }

  /// Called when the window is maximized.
  @override
  void onWindowMaximize() {
    setState(() {
      focused = true;
      maximized = true;
    });
  }

  /// Called when the window is restored from maximized state.
  @override
  void onWindowRestore() {
    setState(() {
      focused = true;
      maximized = false;
    });
  }

  /// Called when the window enters fullscreen mode.
  @override
  void onWindowEnterFullScreen() {
    setState(() => maximized = true);
  }

  /// Called when the window exits fullscreen mode.
  @override
  void onWindowLeaveFullScreen() {
    setState(() => maximized = false);
  }

  /// Closes the window.
  Future<void> _close() async {
    await toolkit.perform.close();
  }

  /// Minimizes the window.
  Future<void> _minimize() async {
    await toolkit.perform.minimize();
  }

  /// Maximizes or enters fullscreen mode for the window.
  Future<void> _maximize() async {
    await toolkit.perform.fullscreen();
  }

  @override
  void dispose() {
    /// Remove the listener to avoid memory leaks.
    toolkit.removeListener(this);
    super.dispose();
  }

  /// Builds a single button with customizable properties.
  ///
  /// - [onPressed]: Callback function for button clicks.
  /// - [color]: Background color of the button.
  /// - [path]: Path to the SVG icon to display on the button.
  Widget _buildButton({VoidCallback? onPressed, required Color color, String? path}) {
    final active = hovering || focused;
    final backgroundColor = active ? color : CupertinoColors.inactiveGray.withOpacity(0.4);

    return MacosIconButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      icon: path != null
          ? Visibility(
              visible: hovering,
              child: SvgPicture.asset(path, fit: BoxFit.scaleDown),
            )
          : SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 92),
      child: MouseRegion(
        /// Update the `hovering` state when the mouse enters or exits the area.
        onEnter: (_) => setState(() => hovering = true),
        onExit: (_) => setState(() => hovering = false),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            gap(width: 20),

            /// Close button with red color.
            _buildButton(
              onPressed: _close,
              color: Color(0xFFFF5F57),
              path: 'packages/window_toolkit/assets/icons/close.svg',
            ),
            gap(),

            /// Minimize button with yellow color, disabled when maximized.
            _buildButton(
              onPressed: maximized ? null : _minimize,
              color: maximized ? CupertinoColors.inactiveGray.withOpacity(0.4) : Color(0xFFFEBC2E),
              path: maximized ? null : 'packages/window_toolkit/assets/icons/minimize.svg',
            ),
            gap(),

            /// Maximize button with green color, changes icon when maximized.
            _buildButton(
              onPressed: _maximize,
              color: Color(0xFF28C840),
              path: maximized
                  ? 'packages/window_toolkit/assets/icons/resize.svg'
                  : 'packages/window_toolkit/assets/icons/maximize.svg',
            ),
            gap(width: 20),
          ],
        ),
      ),
    );
  }

  /// Adds spacing between buttons.
  ///
  /// - [width]: Optional width of the gap (default is 8.0).
  Widget gap({double? width}) => SizedBox(width: width ?? 8.0);
}
