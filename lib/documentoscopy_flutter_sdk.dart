import 'documentoscopy_flutter_sdk_data.dart';
import 'documentoscopy_flutter_sdk_platform_interface.dart';

class DocumentoscopyFlutterSdk {
  Future<String?> getPlatformVersion() {
    return DocumentoscopyFlutterSdkPlatform.instance.getPlatformVersion();
  }

  Future<CSDocumentosCopyResult> openCSDocumentosCopy(String clientId, String clientSecretId, String? identifierId, String? cpf) {
    return DocumentoscopyFlutterSdkPlatform.instance.openCSDocumentosCopy(clientId, clientSecretId, identifierId, cpf);
  }
}
