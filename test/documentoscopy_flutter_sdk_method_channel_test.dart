import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:documentoscopy_flutter_sdk/documentoscopy_flutter_sdk_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDocumentoscopyFlutterSdk platform = MethodChannelDocumentoscopyFlutterSdk();
  const MethodChannel channel = MethodChannel('documentoscopy_flutter_sdk');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
