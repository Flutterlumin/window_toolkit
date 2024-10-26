import 'window_toolkit_platform_interface.dart';

class WindowToolkit {
  Future<String?> getPlatformVersion() {
    return WindowToolkitPlatform.instance.getPlatformVersion();
  }
}
