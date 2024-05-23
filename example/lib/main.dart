import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:documentoscopy_flutter_sdk/documentoscopy_flutter_sdk.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _documentoscopyFlutterSdkPlugin = DocumentoscopyFlutterSdk();
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formValues = {};
  String _result = "N/A";

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> callCSDocumentosCopySDK(String clientId, String clientSecretId, String? identifierId, String? cpf) async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    String result;

    try {
      var sdkResponse =
          await _documentoscopyFlutterSdkPlugin.openCSDocumentosCopy(
            clientId,
            clientSecretId,
            identifierId,
            cpf
          );

      result = jsonEncode(sdkResponse);
    } on PlatformException catch (e) {
      result = "Error: $e";
    } catch (e) {
      result = "Error: $e";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputMask = MaskTextInputFormatter(
        mask: '###.###.###-##',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CSDocumentosCopy'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onSaved: (String? clientIdValue) => _formValues["clientId"] = clientIdValue!,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Text is empty';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter clientId',
                            label: Text("ClientId *")
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onSaved: (String? clientSecretIdValue) => _formValues["clientSecretId"] = clientSecretIdValue!,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Text is empty';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter clientSecretId',
                            label: Text("ClientSecretId *")
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onSaved: (String? identifierIdValue) => _formValues["identifierId"] = identifierIdValue,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Text is empty';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter identifierId',
                            label: Text("IdentifierId *")
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onSaved: (String? cpfValue) => _formValues["cpf"] = cpfValue,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Text is empty';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter CPF',
                            label: Text('CPF')
                        ),
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '###.###.###-##',
                            filter: { "#": RegExp(r'[0-9]') },
                            type: MaskAutoCompletionType.lazy
                          )
                        ],
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(onPressed: () async {
                        if (_formKey.currentState?.validate() == true) {
                          _formKey.currentState!.save();

                          await callCSDocumentosCopySDK(
                              _formValues["clientId"],
                              _formValues["clientSecretId"],
                              _formValues["identifierId"],
                              _formValues["cpf"]
                          );
                        }
                      }, child: const Text('Open CSDocumentosCopy'))
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text("Result is: $_result"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
