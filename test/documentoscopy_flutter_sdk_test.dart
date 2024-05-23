import 'package:flutter_test/flutter_test.dart';
import 'package:documentoscopy_flutter_sdk/documentoscopy_flutter_sdk.dart';
import 'package:documentoscopy_flutter_sdk/documentoscopy_flutter_sdk_platform_interface.dart';
import 'package:documentoscopy_flutter_sdk/documentoscopy_flutter_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDocumentoscopyFlutterSdkPlatform
    with MockPlatformInterfaceMixin
    implements DocumentoscopyFlutterSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DocumentoscopyFlutterSdkPlatform initialPlatform = DocumentoscopyFlutterSdkPlatform.instance;

  test('$MethodChannelDocumentoscopyFlutterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDocumentoscopyFlutterSdk>());
  });

  test('getPlatformVersion', () async {
    DocumentoscopyFlutterSdk documentoscopyFlutterSdkPlugin = DocumentoscopyFlutterSdk();
    MockDocumentoscopyFlutterSdkPlatform fakePlatform = MockDocumentoscopyFlutterSdkPlatform();
    DocumentoscopyFlutterSdkPlatform.instance = fakePlatform;

    expect(await documentoscopyFlutterSdkPlugin.getPlatformVersion(), '42');
  });
}
