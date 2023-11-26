import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_libsodium_pt2/flutter_libsodium_pt2.dart';
import 'package:flutter_libsodium_pt2/flutter_libsodium_pt2_platform_interface.dart';
import 'package:flutter_libsodium_pt2/flutter_libsodium_pt2_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLibsodiumPt2Platform
    with MockPlatformInterfaceMixin
    implements FlutterLibsodiumPt2Platform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterLibsodiumPt2Platform initialPlatform = FlutterLibsodiumPt2Platform.instance;

  test('$MethodChannelFlutterLibsodiumPt2 is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLibsodiumPt2>());
  });

  test('getPlatformVersion', () async {
    FlutterLibsodiumPt2 flutterLibsodiumPt2Plugin = FlutterLibsodiumPt2();
    MockFlutterLibsodiumPt2Platform fakePlatform = MockFlutterLibsodiumPt2Platform();
    FlutterLibsodiumPt2Platform.instance = fakePlatform;

    expect(await flutterLibsodiumPt2Plugin.getPlatformVersion(), '42');
  });
}
