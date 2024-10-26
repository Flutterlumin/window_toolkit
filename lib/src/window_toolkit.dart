import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:window_toolkit/src/titlebar.dart';
import 'package:window_toolkit/src/utils/calculate_window_position.dart';
import 'package:window_toolkit/src/window.dart';
import 'package:window_toolkit/window_toolkit_platform_interface.dart';

class WindowToolkit {
  WindowToolkit._() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  static final WindowToolkit instance = WindowToolkit._();
  final Define define = Define();
  final Check check = Check();
  final Perform perform = Perform();
  final MethodChannel _channel = const MethodChannel('toolkit');

  Future<void> _methodCallHandler(MethodCall call) async {
    if (call.method != 'onEvent') throw UnimplementedError();
  }

  Future<void> initialize([VoidCallback? callback]) async {
    await _channel.invokeMethod('initialize');
  }

  Future<void> titlebar([Titlebar? titlebar]) async {
    if (titlebar != null) {
      Map<String, dynamic> arguments = {
        'style': titlebar.style?.name,
      };
      await _channel.invokeMethod('titlebar', arguments);
    }
  }

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
    }
  }

  Future<String?> getPlatformVersion() {
    return WindowToolkitPlatform.instance.getPlatformVersion();
  }
}

class Define {
  Define();

  // Set whether the window is movable
  Future<void> movable(bool value) async {
    Map<String, dynamic> argument = {'movable': value};
    await WindowToolkit.instance._channel.invokeMethod('set_movable', argument);
  }

  // Set whether the window is closable
  Future<void> closable(bool value) async {
    Map<String, dynamic> argument = {'closable': value};
    await WindowToolkit.instance._channel.invokeMethod('set_closable', argument);
  }

  // Set whether the window is minimizable
  Future<void> minimizable(bool value) async {
    Map<String, dynamic> argument = {'minimizable': value};
    await WindowToolkit.instance._channel.invokeMethod('set_minimizable', argument);
  }

  // Set whether the window is maximizable
  Future<void> maximizable(bool value) async {
    Map<String, dynamic> argument = {'maximizable': value};
    await WindowToolkit.instance._channel.invokeMethod('set_maximizable', argument);
  }

  // Set the window opacity
  Future<void> opacity(double value) async {
    Map<String, dynamic> argument = {'opacity': value};
    await WindowToolkit.instance._channel.invokeMethod('set_opacity', argument);
  }

  /// Sets the maximum size of window to `width` and `height`.
  Future<void> maximumSize(Size size) async {
    final Map<String, dynamic> arguments = {
      'width': size.width,
      'height': size.height,
    };
    await WindowToolkit.instance._channel.invokeMethod('set_maximum_size', arguments);
  }

  /// Sets the maximum size of window to `width` and `height`.
  Future<void> minimumSize(Size size) async {
    final Map<String, dynamic> arguments = {
      'width': size.width,
      'height': size.height,
    };
    await WindowToolkit.instance._channel.invokeMethod('set_minimum_size', arguments);
  }

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

  Future<void> size(Size size, {bool animate = false}) async {
    await bounds(null, size: size, animate: animate);
  }

  Future<void> center({bool animate = false}) async {
    Rect bound = await WindowToolkit.instance.check.bounds();
    Offset position = await calculateWindowPosition(bound.size, Alignment.center);
    await bounds(null, position: position, animate: animate);
  }

  Future<void> align(Alignment alignment, {bool animate = false}) async {
    Rect bound = await WindowToolkit.instance.check.bounds();
    Offset position = await calculateWindowPosition(bound.size, alignment);
    await bounds(null, position: position, animate: animate);
  }
}

class Check {
  Check();
  Future<bool> closable() async => await WindowToolkit.instance._channel.invokeMethod('get_closable');
  Future<bool> minimizable() async => await WindowToolkit.instance._channel.invokeMethod('get_minimizable');
  Future<bool> minimized() async => await WindowToolkit.instance._channel.invokeMethod('get_minimized');
  Future<bool> maximizable() async => await WindowToolkit.instance._channel.invokeMethod('get_maximizable');
  Future<bool> maximized() async => await WindowToolkit.instance._channel.invokeMethod('get_maximized');
  Future<bool> movable() async => await WindowToolkit.instance._channel.invokeMethod('get_movable');
  Future<bool> fullscreen() async => await WindowToolkit.instance._channel.invokeMethod('get_fullscreen');
  Future<double> opacity() async => await WindowToolkit.instance._channel.invokeMethod('get_opacity');

  Future<Rect> bounds() async {
    Map<String, dynamic> arguments = {'devicePixelRatio': PlatformDispatcher.instance.views.first.devicePixelRatio};
    Map<dynamic, dynamic> data = await WindowToolkit.instance._channel.invokeMethod('get_bounds', arguments);

    return Rect.fromLTWH(data['x'], data['y'], data['width'], data['height']);
  }
}

class Perform {
  Perform();

  Future<void> destroy() async {
    await WindowToolkit.instance._channel.invokeMethod('destroy');
  }

  Future<void> close() async {
    await WindowToolkit.instance._channel.invokeMethod('close');
  }

  Future<void> minimize() async {
    await WindowToolkit.instance._channel.invokeMethod('minimize');
  }

  Future<void> maximize() async {
    await WindowToolkit.instance._channel.invokeMethod('maximize');
  }

  Future<void> unmaximize() async {
    await WindowToolkit.instance._channel.invokeMethod('unmaximize');
  }

  Future<void> fullscreen() async => await WindowToolkit.instance._channel.invokeMethod('fullscreen');

  Future<void> darg() async {
    await WindowToolkit.instance._channel.invokeMethod('drag');
  }
}
