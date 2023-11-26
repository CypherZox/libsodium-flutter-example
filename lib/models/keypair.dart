import 'dart:typed_data';

class KeyPair {
  final Uint8List publicKey;
  final Uint8List secretKey;

  KeyPair(this.publicKey, this.secretKey);
}
