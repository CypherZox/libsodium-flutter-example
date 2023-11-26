
import 'flutter_libsodium_pt2_platform_interface.dart';

class FlutterLibsodiumPt2 {
  Future<String?> getPlatformVersion() {
    return FlutterLibsodiumPt2Platform.instance.getPlatformVersion();
  }
}
