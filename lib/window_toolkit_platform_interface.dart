import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'window_toolkit_method_channel.dart';

abstract class WindowToolkitPlatform extends PlatformInterface {
  /// Constructs a WindowToolkitPlatform.
  WindowToolkitPlatform() : super(token: _token);

  static final Object _token = Object();

  static WindowToolkitPlatform _instance = MethodChannelWindowToolkit();

  /// The default instance of [WindowToolkitPlatform] to use.
  ///
  /// Defaults to [MethodChannelWindowToolkit].
  static WindowToolkitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WindowToolkitPlatform] when
  /// they register themselves.
  static set instance(WindowToolkitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
