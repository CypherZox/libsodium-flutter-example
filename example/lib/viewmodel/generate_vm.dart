import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_libsodium_pt2/libsodium_wrapper.dart';
import 'package:flutter_libsodium_pt2/models/keypair.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerateViewModel extends ChangeNotifier {
  final wrapper = LibsodiumWrapper();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _base64DecodedSecretKey = '';
  String _base64DecodedPublicKey = '';
  KeyPair? _keyPair;
  KeyPair? get keyPair => _keyPair;
  String get base64DecodedSecretKey => _base64DecodedSecretKey;
  String get base64DecodedPublicKey => _base64DecodedPublicKey;

  generateKeys() async {
    _keyPair = null;
    _base64DecodedPublicKey = '';
    _base64DecodedSecretKey = '';
    notifyListeners();
    final SharedPreferences prefs = await _prefs;
    final sodiumKeys = await compute(getGeneratedKeyPair, wrapper);

    final base64SecretKey = base64.encode(sodiumKeys.secretKey);
    final base64PublicKey = base64.encode(sodiumKeys.publicKey);

    await prefs.setString('encodedPk', base64PublicKey);
    await prefs.setString('encodedSk', base64SecretKey);

    _keyPair = sodiumKeys;
    _base64DecodedPublicKey = base64PublicKey;
    _base64DecodedSecretKey = base64SecretKey;
    notifyListeners();
  }

  keysClear() {
    _keyPair = null;
    _base64DecodedPublicKey = '';
    _base64DecodedSecretKey = '';
    notifyListeners();
  }
}
