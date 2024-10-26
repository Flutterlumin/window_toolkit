import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'window_toolkit_platform_interface.dart';

/// An implementation of [WindowToolkitPlatform] that uses method channels.
class MethodChannelWindowToolkit extends WindowToolkitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('window_toolkit');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
