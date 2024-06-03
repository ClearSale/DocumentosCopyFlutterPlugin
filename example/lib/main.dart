import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:documentoscopy_flutter_sdk/documentoscopy_flutter_sdk.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

  Color primaryColor = const Color(0xFFFF4800);
  Color secondaryColor = const Color(0xFFFF4800);
  Color tertiaryColor = const Color(0xFFEFEFEF);
  Color titleColor = const Color(0xFF283785);
  Color paragraphColor = const Color(0xFF353840);

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> callCSDocumentosCopySDK(
      String clientId,
      String clientSecretId,
      String identifierId,
      String cpf,
      Color primaryColor,
      Color secondaryColor,
      Color tertiaryColor,
      Color titleColor,
      Color paragraphColor) async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    String result;
    try {
      var sdkResponse =
          await _documentoscopyFlutterSdkPlugin.openCSDocumentosCopy(
              clientId,
              clientSecretId,
              identifierId,
              cpf,
              primaryColor,
              secondaryColor,
              tertiaryColor,
              titleColor,
              paragraphColor);

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
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('CSDocumentosCopy'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          onSaved: (String? clientIdValue) =>
                              _formValues["clientId"] = clientIdValue!,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Text is empty';
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter clientId',
                              label: Text("ClientId *")),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          onSaved: (String? clientSecretIdValue) =>
                              _formValues["clientSecretId"] =
                                  clientSecretIdValue!,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Text is empty';
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter clientSecretId',
                              label: Text("ClientSecretId *")),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          onSaved: (String? identifierIdValue) =>
                              _formValues["identifierId"] = identifierIdValue,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Text is empty';
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter identifierId',
                              label: Text("IdentifierId *")),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          onSaved: (String? cpfValue) =>
                              _formValues["cpf"] = cpfValue,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Text is empty';
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter CPF',
                              label: Text('CPF')),
                          inputFormatters: [
                            MaskTextInputFormatter(
                                mask: '###.###.###-##',
                                filter: {"#": RegExp(r'[0-9]')},
                                type: MaskAutoCompletionType.lazy)
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Text("Primary Color"),
                                ElevatedButton(
                                    onPressed: () async {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Color picker'),
                                            content: SingleChildScrollView(
                                                child: ColorPicker(
                                              enableAlpha: false,
                                              pickerColor: primaryColor,
                                              onColorChanged: (Color color) {
                                                setState(() {
                                                  primaryColor = color;
                                                });
                                              },
                                            )),
                                            actions: <Widget>[
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge,
                                                ),
                                                child: const Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(primaryColor.toHexString(enableAlpha: false))),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Secondary Color"),
                                ElevatedButton(
                                    onPressed: () async {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Color picker'),
                                            content: SingleChildScrollView(
                                                child: ColorPicker(
                                              pickerColor: secondaryColor,
                                              onColorChanged: (Color color) {
                                                setState(() {
                                                  secondaryColor = color;
                                                });
                                              },
                                            )),
                                            actions: <Widget>[
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge,
                                                ),
                                                child: const Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(secondaryColor.toHexString(enableAlpha: false))),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Text("Tertiary Color"),
                                ElevatedButton(
                                    onPressed: () async {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Color picker'),
                                            content: SingleChildScrollView(
                                                child: ColorPicker(
                                              pickerColor: tertiaryColor,
                                              onColorChanged: (Color color) {
                                                setState(() {
                                                  tertiaryColor = color;
                                                });
                                              },
                                            )),
                                            actions: <Widget>[
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge,
                                                ),
                                                child: const Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(tertiaryColor.toHexString(enableAlpha: false))),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Title Color"),
                                ElevatedButton(
                                    onPressed: () async {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Color picker'),
                                            content: SingleChildScrollView(
                                                child: ColorPicker(
                                              pickerColor: titleColor,
                                              onColorChanged: (Color color) {
                                                setState(() {
                                                  titleColor = color;
                                                });
                                              },
                                            )),
                                            actions: <Widget>[
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge,
                                                ),
                                                child: const Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(titleColor.toHexString(enableAlpha: false))),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Text("Paragraph Color"),
                                ElevatedButton(
                                    onPressed: () async {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Color picker'),
                                            content: SingleChildScrollView(
                                                child: ColorPicker(
                                              pickerColor: paragraphColor,
                                              onColorChanged: (Color color) {
                                                setState(() {
                                                  paragraphColor = color;
                                                });
                                              },
                                            )),
                                            actions: <Widget>[
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge,
                                                ),
                                                child: const Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(paragraphColor.toHexString(enableAlpha: false))),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState?.validate() == true) {
                                _formKey.currentState!.save();

                                await callCSDocumentosCopySDK(
                                    _formValues["clientId"],
                                    _formValues["clientSecretId"],
                                    _formValues["identifierId"],
                                    _formValues["cpf"],
                                    primaryColor,
                                    secondaryColor,
                                    tertiaryColor,
                                    titleColor,
                                    paragraphColor);
                              }
                            },
                            child: const Text('Open CSDocumentosCopy'))
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Result is: $_result"),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
