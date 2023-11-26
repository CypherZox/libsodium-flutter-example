import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ffi/ffi.dart' as ffi;

import 'package:flutter/services.dart';
import 'package:flutter_libsodium_pt2/flutter_libsodium_pt2.dart';
import 'package:flutter_libsodium_pt2/libsodium_bindings.dart';
import 'package:flutter_libsodium_pt2/libsodium_wrapper.dart';
import 'package:flutter_libsodium_pt2/models/keypair.dart';
import 'package:flutter_libsodium_pt2_example/view/generate.dart';
import 'package:flutter_libsodium_pt2_example/viewmodel/generate_vm.dart';
import 'package:flutter_libsodium_pt2_example/viewmodel/sign_vm.dart';
import 'package:flutter_libsodium_pt2_example/viewmodel/veify_vm.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _sodiumVersion = 'Unknown Sodium Version';
  String _platformVersion = 'Unknown';
  final _flutterLibsodiumPt2Plugin = FlutterLibsodiumPt2();
  KeyPair? _keyPair = null;
  String _publicKey = '';
  String _privateKey = '';
  String _encryptedData = '';
  Uint8List? publicKeyList;
  Uint8List? privateKeyList;
  @override
  void initState() {
    super.initState();
    // getSodiumVersion();
    initPlatformState();
    // getSodiumKeyPairs();
  }

  Future<void> getSodiumVersion() async {
    final sodiumVersion = await compute(getSodiumVersionString, wrapper);
    setState(() {
      _sodiumVersion = sodiumVersion;
    });
  }

  Future<void> getSodiumKeyPairs() async {
    final SharedPreferences prefs = await _prefs;
    final sodiumKeys = await compute(getGeneratedKeyPair, wrapper);

    final publicKey = Uint8List.fromList(sodiumKeys.publicKey);
    final base64EncodedPublicKey = base64.encode(publicKey);
    final privateKey = Uint8List.fromList(sodiumKeys.secretKey);
    final base64EncodedPrivateKey = base64.encode(privateKey);
    await prefs.setString('encodedPk', base64EncodedPublicKey);
    await prefs.setString('encodedSk', base64EncodedPrivateKey);
    setState(() {
      publicKeyList = sodiumKeys.publicKey;
      privateKeyList = sodiumKeys.secretKey;
      print(base64EncodedPublicKey);
      print(base64EncodedPrivateKey);
      _keyPair = sodiumKeys;
      _publicKey = base64EncodedPublicKey;
      _privateKey = base64EncodedPrivateKey;
    });
  }

  Future<void> signData() async {
    // final publicKeyPointer = ffi.calloc<Uint8>(cryptoSignPublicKeyBytes());
    // final secretKeyPointer = ffi.calloc<Uint8>(cryptoSignSecretKeyBytes());

    final KeyPair keyPairr = await compute(getGeneratedKeyPair, wrapper);
    // final newPkAllocatorN = ffi.calloc<Uint8>(cryptoSignPublicKeyBytes());
    final newPkAllocator = sodiumMalloc(cryptoSignPublicKeyBytes());
    newPkAllocator
        .asTypedList(cryptoSignPublicKeyBytes())
        .setAll(0, keyPairr.publicKey);

    // final newSkAllocatorN = ffi.calloc<Uint8>(cryptoSignSecretKeyBytes());
    final newSkAllocator = sodiumMalloc(cryptoSignSecretKeyBytes());
    newSkAllocator
        .asTypedList(cryptoSignSecretKeyBytes())
        .setAll(0, keyPairr.secretKey);
    final m =
        Uint8List.fromList('FORyouIwouldFallFromGrace'.codeUnits); // Message
    final sig = Uint8List(
        crypto_sign_BYTES()); // Adjust the size based on crypto_sign_BYTES
    final siglenPtr =
        ffi.calloc<Uint64>(); // To store the length of the signature
    final mPtr = ffi.calloc<Uint8>(m.length);

    // final sigPtr = ffi.calloc<Uint8>(sig.length);
    final sigAllocator = sodiumMalloc(sig.length);
    final pkkAllocator = sodiumMalloc(cryptoSignPublicKeyBytes());
    print(pkkAllocator.value);

    mPtr.asTypedList(m.length).setAll(0, m);
    // skPtr.asTypedList(sk.length).setAll(0, sk);
    // pkPtr.asTypedList(pk.length).setAll(0, pk);
    // sodiumFree(pkAllocator);
    try {
      final signResult = cryptoSignDetached(
        sigAllocator,
        nullptr,
        mPtr,
        m.length,
        newSkAllocator,
      );
      if (signResult == 0) {
        final siigg =
            Uint8List.fromList(sigAllocator.asTypedList(crypto_sign_BYTES()));
        final siiggAllocator = sodiumMalloc(crypto_sign_BYTES());
        print(siiggAllocator.value);
        siiggAllocator.asTypedList(crypto_sign_BYTES()).setAll(0, siigg);
        print(
            'Signature created successfully! Signature length: ${siglenPtr.value}');
        // if (sigPtr.value != 0) {
        try {
          final verifyResult = cryptoSignVerifyDetached(
            siiggAllocator,
            mPtr,
            m.length,
            newPkAllocator,
          );

          if (verifyResult == 0) {
            print('Signature is valid!');
          } else {
            print('Signature verification failed: $verifyResult');
          }
        } catch (e) {}
        // }
      } else {
        print('Error creating signature: $signResult');
      }
    } catch (e) {
      print(e);
    }
    // sigPtr.asTypedList(sig.length).setRange(0, sig.length,
    //     Uint8List.fromList(sigPtr.asTypedList(crypto_sign_BYTES())));

    ffi.calloc.free(siglenPtr);
    ffi.calloc.free(mPtr);

    // ffi.calloc.free(sigPtr);
    // ffi.calloc.free(publicKeyPointer);
    // ffi.calloc.free(secretKeyPointer);

    setState(() {
      // _encryptedData = encryptedData;
    });
  }

  verify() async {}

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterLibsodiumPt2Plugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
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
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false, home: GenerateKeysWidget()
          // Scaffold(
          //   appBar: AppBar(
          //     title: const Text('Plugin example app'),
          //   ),
          //   body: Column(
          //     children: [
          //       Center(
          //         child: Text('Running on: $_platformVersion\n'),
          //       ),
          //       Text('Sodium version on_: $_sodiumVersion\n'),
          //       Text('Private key: $_privateKey\n'),
          //       MaterialButton(
          //           color: Colors.pinkAccent.withOpacity(0.3),
          //           elevation: 0,
          //           child: Text('Try to sign'),
          //           onPressed: () {
          //             signData();
          //           })
          //     ],
          //   ),
          // ),
          ),
    );
  }
}
