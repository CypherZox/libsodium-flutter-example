import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_libsodium_pt2/flutter_libsodium_pt2.dart';
import 'package:flutter_libsodium_pt2/libsodium_wrapper.dart';
import 'package:flutter_libsodium_pt2_example/view/generate.dart';
import 'package:flutter_libsodium_pt2_example/viewmodel/generate_vm.dart';
import 'package:flutter_libsodium_pt2_example/viewmodel/sign_vm.dart';
import 'package:flutter_libsodium_pt2_example/viewmodel/veify_vm.dart';
import 'package:provider/provider.dart';

import 'viewmodel/audio_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final wrapper = LibsodiumWrapper();

  final _flutterLibsodiumPt2Plugin = FlutterLibsodiumPt2();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    try {
      await _flutterLibsodiumPt2Plugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      'Failed to get platform version.';
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignViewModel>(
            create: (context) => SignViewModel()),
        ChangeNotifierProvider<VerifyViewModel>(
            create: (context) => VerifyViewModel()),
        ChangeNotifierProvider<GenerateViewModel>(
            create: (context) => GenerateViewModel()),
        ChangeNotifierProvider<AudioController>(
            create: (context) => AudioController()),
      ], //
      child: const MaterialApp(
          debugShowCheckedModeBanner: false, home: GenerateKeysWidget()),
    );
  }
}
