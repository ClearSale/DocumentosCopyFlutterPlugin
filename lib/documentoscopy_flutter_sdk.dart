
import 'documentoscopy_flutter_sdk_platform_interface.dart';

class DocumentoscopyFlutterSdk {
  Future<String?> getPlatformVersion() {
    return DocumentoscopyFlutterSdkPlatform.instance.getPlatformVersion();
  }
}
