import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libsodium_pt2/libsodium_wrapper.dart';

class VerifyViewModel extends ChangeNotifier {
  final wrapper = LibsodiumWrapper();

  TextEditingController _signatureController = TextEditingController();
  TextEditingController _publicKeyController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  TextEditingController get signatureController => _signatureController;
  TextEditingController get publicKeyController => _publicKeyController;
  TextEditingController get messageController => _messageController;

  Future<int> verifyMessage(
      String base64PublicKey, String base64Signature, String message) async {
    Uint8List publicKeyList = base64.decode(base64PublicKey);
    Uint8List signatureList = base64.decode(base64Signature);
    try {
      final signResult = await compute(cryptoSignDetachedVerification,
          CryptoVerifySingCall(wrapper, publicKeyList, signatureList, message));
      return signResult;
    } catch (e) {
      return -1;
    }
  }

  clearVerify() {
    _signatureController = TextEditingController();
    _publicKeyController = TextEditingController();
    _messageController = TextEditingController();
    notifyListeners();
  }
}
