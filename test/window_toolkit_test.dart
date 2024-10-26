import 'package:flutter_test/flutter_test.dart';
import 'package:window_toolkit/window_toolkit.dart';
import 'package:window_toolkit/window_toolkit_platform_interface.dart';
import 'package:window_toolkit/window_toolkit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWindowToolkitPlatform
    with MockPlatformInterfaceMixin
    implements WindowToolkitPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final WindowToolkitPlatform initialPlatform = WindowToolkitPlatform.instance;

  test('$MethodChannelWindowToolkit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWindowToolkit>());
  });

  test('getPlatformVersion', () async {
    WindowToolkit windowToolkitPlugin = WindowToolkit();
    MockWindowToolkitPlatform fakePlatform = MockWindowToolkitPlatform();
    WindowToolkitPlatform.instance = fakePlatform;

    expect(await windowToolkitPlugin.getPlatformVersion(), '42');
  });
}
