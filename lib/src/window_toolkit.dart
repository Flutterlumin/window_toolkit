import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:window_toolkit/src/titlebar.dart';
import 'package:window_toolkit/src/utils/calculate_window_position.dart';
import 'package:window_toolkit/src/window.dart';
import 'package:window_toolkit/window_toolkit_platform_interface.dart';
import 'package:flutter/material.dart';

/// A toolkit for managing window properties and appearance on macOS.
///
/// Provides capabilities to control window behavior, title bar appearance, resizing,
/// alignment, opacity, and other window properties.
class WindowToolkit {
  WindowToolkit._() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  /// Singleton instance of WindowToolkit.
  static final WindowToolkit instance = WindowToolkit._();

  /// Provides functionalities to define window properties.
  final Define define = Define();

  /// Provides functionalities to check the state of various window properties.
  final Check check = Check();

  /// Provides functionalities to perform actions on the window.
  final Perform perform = Perform();

  /// The communication channel for platform-specific window operations.
  final MethodChannel _channel = const MethodChannel('toolkit');

  /// Private field to store the current window.
  Window? _currentWindow;

  /// Getter for the current window.
  Window? get currentWindow => _currentWindow;

  /// Handles incoming method calls from the platform.
  Future<void> _methodCallHandler(MethodCall call) async {
    if (call.method != 'onEvent') throw UnimplementedError();
  }

  /// Initializes the window toolkit.
  Future<void> initialize([VoidCallback? callback]) async {
    await _channel.invokeMethod('initialize');
    if (callback != null) callback;
  }

  /// Configures the title bar properties.
  Future<void> titlebar([Titlebar? titlebar]) async {
    if (titlebar != null) {
      Map<String, dynamic> arguments = {
        'style': titlebar.style?.name,
      };
      await _channel.invokeMethod('titlebar', arguments);
    }
  }

  /// Sets various window properties if specified.
  Future<void> window([Window? window]) async {
    if (window != null) {
      if (window.movable != null) define.movable(window.movable!);
      if (window.closable != null) define.closable(window.closable!);
      if (window.minimizable != null) define.minimizable(window.minimizable!);
      if (window.maximizable != null) define.maximizable(window.maximizable!);
      if (window.center != null && window.center == true) define.align(Alignment.center);
      if (window.opacity != null) define.opacity(window.opacity!);
      if (window.size != null) define.size(window.size!);
      if (window.minimumSize != null) define.minimumSize(window.minimumSize!);
      if (window.maximumSize != null) define.maximumSize(window.maximumSize!);

      // Set the current window
      _currentWindow = window;
    }
  }

  /// Retrieves the platform version.
  Future<String?> getPlatformVersion() {
    return WindowToolkitPlatform.instance.getPlatformVersion();
  }
}

/// Provides methods to define and set various window properties.
///
/// The `Define` class allows configuration of properties like movability,
/// closability, resizability, opacity, and window size constraints.
class Define {
  Define();

  /// Sets whether the window is movable by the user.
  ///
  /// The window can be dragged around the screen when `value` is set to `true`.
  Future<void> movable(bool value) async {
    Map<String, dynamic> argument = {'movable': value};
    await WindowToolkit.instance._channel.invokeMethod('set_movable', argument);
  }

  /// Sets whether the window can be closed by the user.
  ///
  /// The window displays a close button and can be closed if `value` is set to `true`.
  Future<void> closable(bool value) async {
    Map<String, dynamic> argument = {'closable': value};
    await WindowToolkit.instance._channel.invokeMethod('set_closable', argument);
  }

  /// Sets whether the window can be minimized by the user.
  ///
  /// The window displays a minimize button and can be minimized if `value` is `true`.
  Future<void> minimizable(bool value) async {
    Map<String, dynamic> argument = {'minimizable': value};
    await WindowToolkit.instance._channel.invokeMethod('set_minimizable', argument);
  }

  /// Sets whether the window can be maximized by the user.
  ///
  /// When `value` is `true`, the window can be expanded to fill the screen.
  Future<void> maximizable(bool value) async {
    Map<String, dynamic> argument = {'maximizable': value};
    await WindowToolkit.instance._channel.invokeMethod('set_maximizable', argument);
  }

  /// Sets the window's opacity.
  ///
  /// The `value` should be a double between 0.0 (completely transparent)
  /// and 1.0 (completely opaque).
  Future<void> opacity(double value) async {
    Map<String, dynamic> argument = {'opacity': value};
    await WindowToolkit.instance._channel.invokeMethod('set_opacity', argument);
  }

  /// Sets the maximum size of the window.
  ///
  /// Limits the window size to `width` and `height`.
  Future<void> maximumSize(Size size) async {
    final Map<String, dynamic> arguments = {
      'width': size.width,
      'height': size.height,
    };
    await WindowToolkit.instance._channel.invokeMethod('set_maximum_size', arguments);
  }

  /// Sets the minimum size of the window.
  ///
  /// Prevents the window from being resized smaller than `width` and `height`.
  Future<void> minimumSize(Size size) async {
    final Map<String, dynamic> arguments = {
      'width': size.width,
      'height': size.height,
    };
    await WindowToolkit.instance._channel.invokeMethod('set_minimum_size', arguments);
  }

  /// Sets the bounds of the window, including position and size.
  ///
  /// The `bounds` parameter specifies the area, `position` sets the top-left corner,
  /// `size` determines the window's width and height, and `animate` controls
  /// whether the change is animated.
  Future<void> bounds(Rect? bounds, {Offset? position, Size? size, bool animate = false}) async {
    Map<String, dynamic> arguments = {
      'devicePixelRatio': PlatformDispatcher.instance.views.first.devicePixelRatio,
      'x': bounds?.topLeft.dx ?? position?.dx,
      'y': bounds?.topLeft.dy ?? position?.dy,
      'width': bounds?.size.width ?? size?.width,
      'height': bounds?.size.height ?? size?.height,
      'animate': animate,
    }..removeWhere((key, value) => value == null);
    await WindowToolkit.instance._channel.invokeMethod('set_bounds', arguments);
  }

  /// Sets the window's size to the specified width and height.
  ///
  /// Optionally, the resize can be animated if `animate` is `true`.
  Future<void> size(Size size, {bool animate = false}) async {
    await bounds(null, size: size, animate: animate);
  }

  /// Centers the window on the screen.
  ///
  /// If `animate` is `true`, the centering action is animated.
  Future<void> center({bool animate = false}) async {
    Rect bound = await WindowToolkit.instance.check.bounds();
    Offset position = await calculateWindowPosition(bound.size, Alignment.center);
    await bounds(null, position: position, animate: animate);
  }

  /// Aligns the window according to a specified alignment on the screen.
  ///
  /// The `alignment` parameter defines the alignment type,
  /// and the action is animated if `animate` is `true`.
  Future<void> align(Alignment alignment, {bool animate = false}) async {
    Rect bound = await WindowToolkit.instance.check.bounds();
    Offset position = await calculateWindowPosition(bound.size, alignment);
    await bounds(null, position: position, animate: animate);
  }
}

/// Provides methods to check the current state of various window properties.
///
/// The `Check` class allows you to verify properties such as whether the window is
/// closable, minimizable, maximized, movable, in fullscreen mode, and more.
class Check {
  Check();

  /// Checks if the window is closable.
  Future<bool> closable() async {
    return await WindowToolkit.instance._channel.invokeMethod('get_closable');
  }

  /// Checks if the window is minimizable.
  Future<bool> minimizable() async {
    return await WindowToolkit.instance._channel.invokeMethod('get_minimizable');
  }

  /// Checks if the window is currently minimized.
  Future<bool> minimized() async {
    return await WindowToolkit.instance._channel.invokeMethod('get_minimized');
  }

  /// Checks if the window is maximizable.
  Future<bool> maximizable() async {
    return await WindowToolkit.instance._channel.invokeMethod('get_maximizable');
  }

  /// Checks if the window is currently maximized.
  Future<bool> maximized() async {
    return await WindowToolkit.instance._channel.invokeMethod('get_maximized');
  }

  /// Checks if the window is movable.
  Future<bool> movable() async {
    return await WindowToolkit.instance._channel.invokeMethod('get_movable');
  }

  /// Checks if the window is currently in fullscreen mode.
  Future<bool> fullscreen() async {
    return await WindowToolkit.instance._channel.invokeMethod('get_fullscreen');
  }

  /// Retrieves the current opacity level of the window.
  ///
  /// Returns a `double` representing the window's opacity, where 1.0 is fully opaque.
  Future<double> opacity() async {
    return await WindowToolkit.instance._channel.invokeMethod('get_opacity');
  }

  /// Retrieves the current bounds (position and size) of the window.
  ///
  /// Returns a `Rect` representing the window's position and size in the screen.
  Future<Rect> bounds() async {
    Map<String, dynamic> arguments = {
      'devicePixelRatio': PlatformDispatcher.instance.views.first.devicePixelRatio
    };
    Map<dynamic, dynamic> data =
        await WindowToolkit.instance._channel.invokeMethod('get_bounds', arguments);

    return Rect.fromLTWH(data['x'], data['y'], data['width'], data['height']);
  }
}

/// Provides methods to perform various actions on the window.
///
/// The `Perform` class allows you to manipulate the window, such as minimizing,
/// maximizing, closing, entering fullscreen, and dragging.
class Perform {
  Perform();

  /// Destroys the window.
  ///
  /// This action closes the window and removes it from memory.
  Future<void> destroy() async {
    await WindowToolkit.instance._channel.invokeMethod('destroy');
  }

  /// Closes the window.
  ///
  /// This action hides the window but does not destroy it, allowing it to be reopened.
  Future<void> close() async {
    await WindowToolkit.instance._channel.invokeMethod('close');
  }

  /// Minimizes the window.
  Future<void> minimize() async {
    await WindowToolkit.instance._channel.invokeMethod('minimize');
  }

  /// Maximizes the window.
  ///
  /// Expands the window to fill the available screen space.
  Future<void> maximize() async {
    await WindowToolkit.instance._channel.invokeMethod('maximize');
  }

  /// Restores the window to its original size if it is maximized.
  Future<void> unmaximize() async {
    await WindowToolkit.instance._channel.invokeMethod('unmaximize');
  }

  /// Toggles fullscreen mode for the window.
  ///
  /// Expands the window to fill the entire screen, hiding the title bar and borders.
  /// This function will not execute if a maximumSize has been set for the window.
  Future<void> fullscreen() async {
    Window? window = WindowToolkit.instance.currentWindow;

    // Check if maximumSize is defined and if it restricts the window size
    if (window != null) {
      Size? size = window.maximumSize;
      if (size != null && (size.width < double.infinity || size.height < double.infinity)) {
        throw Exception('Cannot enter fullscreen mode; maximum size is set for the window.');
      }
    }

    // If the maximumSize condition is not met, proceed to toggle fullscreen
    await WindowToolkit.instance._channel.invokeMethod('fullscreen');
  }

  /// Allows the user to drag the window around the screen.
  ///
  /// Enables dragging functionality on the title bar or other draggable areas.
  Future<void> drag() async {
    await WindowToolkit.instance._channel.invokeMethod('drag');
  }
}
