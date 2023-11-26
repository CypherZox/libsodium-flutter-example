import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_libsodium_pt2_platform_interface.dart';

/// An implementation of [FlutterLibsodiumPt2Platform] that uses method channels.
class MethodChannelFlutterLibsodiumPt2 extends FlutterLibsodiumPt2Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_libsodium_pt2');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
