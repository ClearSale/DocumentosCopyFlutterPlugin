import 'package:flutter/services.dart';

import 'documentoscopy_flutter_sdk_data.dart';
import 'documentoscopy_flutter_sdk_platform_interface.dart';

class DocumentoscopyFlutterSdk {
  Future<CSDocumentosCopyResult> openCSDocumentosCopy(
      String clientId,
      String clientSecretId,
      String identifierId,
      String cpf,
      Color primaryColor,
      Color secondaryColor,
      Color tertiaryColor,
      Color titleColor,
      Color paragraphColor) {
    return DocumentoscopyFlutterSdkPlatform.instance.openCSDocumentosCopy(
        clientId,
        clientSecretId,
        identifierId,
        cpf,
        primaryColor,
        secondaryColor,
        tertiaryColor,
        titleColor,
        paragraphColor);
  }
}
