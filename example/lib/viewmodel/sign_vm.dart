import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libsodium_pt2/libsodium_wrapper.dart';

class SignViewModel extends ChangeNotifier {
  final wrapper = LibsodiumWrapper();
  Uint8List? _signatureList;
  Uint8List? get signatureList => _signatureList;
  String? _signatureBase64;
  String? get signatureBase64 => _signatureBase64;

  TextEditingController _messageController = TextEditingController();
  TextEditingController get messageController => _messageController;
  signMessage(Uint8List secretKey, String message) async {
    _signatureList = null;
    _signatureBase64 = '';
    notifyListeners();
    print(message);
    final signature = await compute(
        cryptoSignDetachedW, CryptoSingCall(wrapper, secretKey, message));
    if (signature != null) {
      _signatureList = signature;
      _signatureBase64 = base64.encode(signature);
      notifyListeners();
    }
  }

  clearSignature() {
    _signatureList = null;
    _signatureBase64 = '';
    _messageController = TextEditingController();
    notifyListeners();
  }
}
