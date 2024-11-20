import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:window_toolkit/src/titlebar.dart';
import 'package:window_toolkit/src/utils/calculate_window_position.dart';
import 'package:window_toolkit/src/window.dart';
import 'package:window_toolkit/src/window_listener.dart';
import 'package:window_toolkit/window_toolkit_platform_interface.dart';
import 'package:flutter/material.dart';

const kWindowEventFocus = 'focus';
const kWindowEventBlur = 'blur';
const kWindowEventMaximize = 'maximize';
const kWindowEventUnmaximize = 'unmaximize';
const kWindowEventRestore = 'restore';
const kWindowEventEnterFullScreen = 'enter-full-screen';
const kWindowEventLeaveFullScreen = 'leave-full-screen';

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

  /// Lazy initialization for `define`, `check`, and `perform` instances.
  late final Define define = Define();
  late final Check check = Check();
  late final Perform perform = Perform();

  /// The communication channel for platform-specific window operations.
  final MethodChannel _channel = const MethodChannel('toolkit');

  /// Private field to store the current window.
  Window? _currentWindow;

  /// Getter for the current window.
  Window? get currentWindow => _currentWindow;

  final ObserverList<WindowListener> _listeners = ObserverList<WindowListener>();

  /// Handles incoming method calls from the platform.
  Future<void> _methodCallHandler(MethodCall call) async {
    for (final WindowListener listener in listeners) {
      if (!_listeners.contains(listener)) {
        return;
      }

      if (call.method != 'onEvent') throw UnimplementedError();

      String event = call.arguments['eventName'];
      listener.onWindowEvent(event);
      Map<String, Function> map = {
        kWindowEventFocus: listener.onWindowFocus,
        kWindowEventBlur: listener.onWindowBlur,
        kWindowEventRestore: listener.onWindowRestore,
        kWindowEventMaximize: listener.onWindowMaximize,
        kWindowEventUnmaximize: listener.onWindowUnmaximize,
        kWindowEventEnterFullScreen: listener.onWindowEnterFullScreen,
        kWindowEventLeaveFullScreen: listener.onWindowLeaveFullScreen,
      };
      map[event]?.call();
    }
  }

  List<WindowListener> get listeners {
    List<WindowListener> localListeners = List<WindowListener>.from(_listeners);
    return localListeners;
  }

  bool get hasListeners {
    return _listeners.isNotEmpty;
  }

  void addListener(WindowListener listener) {
    _listeners.add(listener);
  }

  void removeListener(WindowListener listener) {
    _listeners.remove(listener);
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
      if (window.movable != null) {
        define.movable(window.movable!);
      }
      if (window.closable != null) {
        define.closable(window.closable!);
      }
      if (window.minimizable != null) {
        define.minimizable(window.minimizable!);
      }
      if (window.maximizable != null) {
        define.maximizable(window.maximizable!);
      }
      if (window.center != null && window.center == true) {
        define.align(Alignment.center);
      }
      if (window.opacity != null) {
        define.opacity(window.opacity!);
      }
      if (window.size != null) define.size(window.size!);
      if (window.minimumSize != null) {
        define.minimumSize(window.minimumSize!);
      }
      if (window.maximumSize != null) {
        define.maximumSize(window.maximumSize!);
      }

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

  final MethodChannel _channel = WindowToolkit.instance._channel;

  /// Sets whether the window is movable by the user.
  ///
  /// The window can be dragged around the screen when `value` is set to `true`.
  Future<void> movable(bool value) async {
    Map<String, dynamic> argument = {'movable': value};
    await _channel.invokeMethod('set_movable', argument);
  }

  /// Sets whether the window can be closed by the user.
  ///
  /// The window displays a close button and can be closed if `value` is set to `true`.
  Future<void> closable(bool value) async {
    Map<String, dynamic> argument = {'closable': value};
    await _channel.invokeMethod('set_closable', argument);
  }

  /// Sets whether the window can be minimized by the user.
  ///
  /// The window displays a minimize button and can be minimized if `value` is `true`.
  Future<void> minimizable(bool value) async {
    Map<String, dynamic> argument = {'minimizable': value};
    await _channel.invokeMethod('set_minimizable', argument);
  }

  /// Sets whether the window can be maximized by the user.
  ///
  /// When `value` is `true`, the window can be expanded to fill the screen.
  Future<void> maximizable(bool value) async {
    Map<String, dynamic> argument = {'maximizable': value};
    await _channel.invokeMethod('set_maximizable', argument);
  }

  /// Sets the window's opacity.
  ///
  /// The `value` should be a double between 0.0 (completely transparent)
  /// and 1.0 (completely opaque).
  Future<void> opacity(double value) async {
    Map<String, dynamic> argument = {'opacity': value};
    await _channel.invokeMethod('set_opacity', argument);
  }

  /// Sets the maximum size of the window.
  ///
  /// Limits the window size to `width` and `height`.
  Future<void> maximumSize(Size size) async {
    final Map<String, dynamic> arguments = {
      'width': size.width,
      'height': size.height,
    };
    await _channel.invokeMethod('set_maximum_size', arguments);
  }

  /// Sets the minimum size of the window.
  ///
  /// Prevents the window from being resized smaller than `width` and `height`.
  Future<void> minimumSize(Size size) async {
    final Map<String, dynamic> arguments = {
      'width': size.width,
      'height': size.height,
    };
    await _channel.invokeMethod('set_minimum_size', arguments);
  }

  /// Sets the bounds of the window, including position and size.
  ///
  /// The `bounds` parameter specifies the area, `position` sets the top-left corner,
  /// `size` determines the window's width and height, and `animate` controls
  /// whether the change is animated.
  Future<void> bounds(
    Rect? bounds, {
    Offset? position,
    Size? size,
    bool animate = false,
  }) async {
    FlutterView view = PlatformDispatcher.instance.views.first;
    Map<String, dynamic> arguments = {
      'devicePixelRatio': view.devicePixelRatio,
      'x': bounds?.topLeft.dx ?? position?.dx,
      'y': bounds?.topLeft.dy ?? position?.dy,
      'width': bounds?.size.width ?? size?.width,
      'height': bounds?.size.height ?? size?.height,
      'animate': animate,
    }..removeWhere((key, value) => value == null);
    await _channel.invokeMethod('set_bounds', arguments);
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
    Size size = bound.size;
    Alignment center = Alignment.center;
    Offset position = await calculateWindowPosition(size, center);
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
  static final MethodChannel _channel = WindowToolkit.instance._channel;

  /// Checks if the window is closable.
  Future<bool> closable() async {
    return await _channel.invokeMethod('get_closable');
  }

  /// Checks if the window is minimizable.
  Future<bool> minimizable() async {
    return await _channel.invokeMethod('get_minimizable');
  }

  /// Checks if the window is currently minimized.
  Future<bool> minimized() async {
    return await _channel.invokeMethod('get_minimized');
  }

  /// Checks if the window is maximizable.
  Future<bool> maximizable() async {
    return await _channel.invokeMethod('get_maximizable');
  }

  /// Checks if the window is currently maximized.
  Future<bool> maximized() async {
    return await _channel.invokeMethod('get_maximized');
  }

  /// Checks if the window is movable.
  Future<bool> movable() async {
    return await _channel.invokeMethod('get_movable');
  }

  /// Checks if the window is currently in fullscreen mode.
  Future<bool> fullscreen() async {
    return await _channel.invokeMethod('get_fullscreen');
  }

  /// Retrieves the current opacity level of the window.
  ///
  /// Returns a `double` representing the window's opacity, where 1.0 is fully opaque.
  Future<double> opacity() async {
    return await _channel.invokeMethod('get_opacity');
  }

  /// Retrieves the current bounds (position and size) of the window.
  ///
  /// Returns a `Rect` representing the window's position and size in the screen.
  Future<Rect> bounds() async {
    FlutterView view = PlatformDispatcher.instance.views.first;
    Map<String, dynamic> arguments = {
      'devicePixelRatio': view.devicePixelRatio,
    };
    Map<dynamic, dynamic> data = await _channel.invokeMethod(
      'get_bounds',
      arguments,
    );

    return Rect.fromLTWH(
      data['x'],
      data['y'],
      data['width'],
      data['height'],
    );
  }
}

/// Provides methods to perform various actions on the window.
///
/// The `Perform` class allows you to manipulate the window, such as minimizing,
/// maximizing, closing, entering fullscreen, and dragging.
class Perform {
  Perform();
  static final MethodChannel _channel = WindowToolkit.instance._channel;

  /// Destroys the window.
  ///
  /// This action closes the window and removes it from memory.
  Future<void> destroy() async {
    await _channel.invokeMethod('destroy');
  }

  /// Closes the window.
  ///
  /// This action hides the window but does not destroy it, allowing it to be reopened.
  Future<void> close() async {
    await _channel.invokeMethod('close');
  }

  /// Minimizes the window.
  Future<void> minimize() async {
    await _channel.invokeMethod('minimize');
  }

  /// Maximizes the window.
  ///
  /// Expands the window to fill the available screen space.
  Future<void> maximize() async {
    await _channel.invokeMethod('maximize');
  }

  /// Restores the window to its original size if it is maximized.
  Future<void> unmaximize() async {
    await _channel.invokeMethod('unmaximize');
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
      double infinity = double.infinity;
      if (size != null && (size.width < infinity || size.height < infinity)) {
        throw Exception(
          'Cannot enter fullscreen mode; maximum size is set for the window.',
        );
      }
    }

    // If the maximumSize condition is not met, proceed to toggle fullscreen
    await _channel.invokeMethod('fullscreen');
  }

  /// Allows the user to drag the window around the screen.
  ///
  /// Enables dragging functionality on the title bar or other draggable areas.
  Future<void> drag() async {
    await _channel.invokeMethod('drag');
  }
}
