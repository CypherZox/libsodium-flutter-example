import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_libsodium_pt2_method_channel.dart';

abstract class FlutterLibsodiumPt2Platform extends PlatformInterface {
  /// Constructs a FlutterLibsodiumPt2Platform.
  FlutterLibsodiumPt2Platform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLibsodiumPt2Platform _instance = MethodChannelFlutterLibsodiumPt2();

  /// The default instance of [FlutterLibsodiumPt2Platform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLibsodiumPt2].
  static FlutterLibsodiumPt2Platform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLibsodiumPt2Platform] when
  /// they register themselves.
  static set instance(FlutterLibsodiumPt2Platform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
