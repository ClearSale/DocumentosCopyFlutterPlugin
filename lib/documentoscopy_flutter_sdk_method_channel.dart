import 'package:documentoscopy_flutter_sdk/documentoscopy_flutter_sdk_extend_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'documentoscopy_flutter_sdk_data.dart';
import 'documentoscopy_flutter_sdk_platform_interface.dart';

/// An implementation of [DocumentoscopyFlutterSdkPlatform] that uses method channels.
class MethodChannelDocumentoscopyFlutterSdk
    extends DocumentoscopyFlutterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('documentoscopy_flutter_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<CSDocumentosCopyResult> openCSDocumentosCopy(
      String clientId,
      String clientSecretId,
      String identifierId,
      String cpf,
      Color primaryColor,
      Color secondaryColor,
      Color tertiaryColor,
      Color titleColor,
      Color paragraphColor) async {
    final Map<dynamic, dynamic>? response =
        await methodChannel.invokeMapMethod('openCSDocumentosCopy', {
      "clientId": clientId,
      "clientSecretId": clientSecretId,
      "identifierId": identifierId,
      "cpf": cpf,
      "primaryColor": primaryColor.toHexString(),
      "secondaryColor": secondaryColor.toHexString(),
      "tertiaryColor": tertiaryColor.toHexString(),
      "titleColor": titleColor.toHexString(),
      "paragraphColor": paragraphColor.toHexString()
    });

    if (response != null) {
      return CSDocumentosCopyResult.fromJson(
          response.cast() as Map<String, dynamic>);
    }

    throw "No response from native side";
  }
}
