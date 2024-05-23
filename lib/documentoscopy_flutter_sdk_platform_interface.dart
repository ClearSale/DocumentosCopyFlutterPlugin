import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'documentoscopy_flutter_sdk_data.dart';
import 'documentoscopy_flutter_sdk_method_channel.dart';

abstract class DocumentoscopyFlutterSdkPlatform extends PlatformInterface {
  /// Constructs a DocumentoscopyFlutterSdkPlatform.
  DocumentoscopyFlutterSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static DocumentoscopyFlutterSdkPlatform _instance =
      MethodChannelDocumentoscopyFlutterSdk();

  /// The default instance of [DocumentoscopyFlutterSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelDocumentoscopyFlutterSdk].
  static DocumentoscopyFlutterSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DocumentoscopyFlutterSdkPlatform] when
  /// they register themselves.
  static set instance(DocumentoscopyFlutterSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

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
    throw UnimplementedError(
        'openCSDocumentosCopy() has not been implemented.');
  }
}
