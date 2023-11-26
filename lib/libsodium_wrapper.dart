import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter_libsodium_pt2/libsodium_bindings.dart' as bindings;
import 'package:flutter_libsodium_pt2/models/keypair.dart';

class LibsodiumError extends Error {}

class LibsodiumCouldNotInitError extends LibsodiumError {}

class LibsodiumWrapper {
  LibsodiumWrapper() {
    if (sodiumInit() < 0) {
      print('=======>sodiumInit() < 0');
      throw LibsodiumCouldNotInitError();
    }
  }

  int sodiumInit() {
    return bindings.sodiumInit();
  }

  String sodiumVersionString() {
    return bindings.sodiumVersionString().toDartString();
  }

  // KeyPair generateKeyPair() {
  //   final int cryptoSignSecretKeyBytes = bindings.cryptoSignSecretKeyBytes();
  //   final int cryptoSignPublicKeyBytes = bindings.cryptoSignPublicKeyBytes();

  //   final publicKeyPointer = calloc<Uint8>(cryptoSignPublicKeyBytes);
  //   final secretKeyPointer = calloc<Uint8>(cryptoSignSecretKeyBytes);
  //   final result =
  //       bindings.cryptoSignKeypair(publicKeyPointer, secretKeyPointer);

  //   if (result != 0) {
  //     throw 'Key pair generation failed with error code: $result';
  //   }

  //   final publicKey = Uint8List.fromList(
  //       publicKeyPointer.asTypedList(cryptoSignSecretKeyBytes));
  //   final secretKey = Uint8List.fromList(
  //       secretKeyPointer.asTypedList(cryptoSignPublicKeyBytes));

  //   calloc.free(publicKeyPointer);
  //   calloc.free(secretKeyPointer);

  //   return KeyPair(publicKey, secretKey);
  // }

  KeyPair generateKeyPair() {
    final publicKeyPointer = calloc<Uint8>(bindings.cryptoSignPublicKeyBytes());
    final secretKeyPointer = calloc<Uint8>(bindings.cryptoSignSecretKeyBytes());
    final pkAllocator =
        bindings.sodiumMalloc(bindings.cryptoSignPublicKeyBytes());
    final skAllocator =
        bindings.sodiumMalloc(bindings.cryptoSignSecretKeyBytes());

    final result = bindings.cryptoSignKeypair(pkAllocator, skAllocator);
    if (result == 0) {
      final pkk = Uint8List.fromList(
          pkAllocator.asTypedList(bindings.cryptoSignPublicKeyBytes()));
      final skk = Uint8List.fromList(
          skAllocator.asTypedList(bindings.cryptoSignSecretKeyBytes()));
      calloc.free(publicKeyPointer);
      calloc.free(secretKeyPointer);
      return KeyPair(pkk, skk);
    } else {
      throw 'Key pair generation failed with error code: $result';
    }
  }

  Uint8List? cryptoSignDetachedWrapping(Uint8List sk, String message) {
    int signResult = 0;
    final skAllocator =
        bindings.sodiumMalloc(bindings.cryptoSignSecretKeyBytes());
    skAllocator.asTypedList(bindings.cryptoSignSecretKeyBytes()).setAll(0, sk);
    final m = Uint8List.fromList(message.codeUnits);
    final sig = Uint8List(bindings.crypto_sign_BYTES());
    final siglenPtr = calloc<Uint64>();
    final mPtr = calloc<Uint8>(m.length);
    final sigAllocator = bindings.sodiumMalloc(sig.length);
    mPtr.asTypedList(m.length).setAll(0, m);
    try {
      signResult = bindings.cryptoSignDetached(
        sigAllocator,
        nullptr,
        mPtr,
        m.length,
        skAllocator,
      );
      final signature = Uint8List.fromList(
          sigAllocator.asTypedList(bindings.crypto_sign_BYTES()));
      return signature;
    } catch (e) {
      throw 'sign failed with sign result: $signResult, $e';
    } finally {
      bindings.sodiumFree(skAllocator);
      bindings.sodiumFree(sigAllocator);
      calloc.free(siglenPtr);
      calloc.free(mPtr);
    }
  }

  int cryptoSignDetachedWrappingVerification(
      Uint8List pk, Uint8List signtrList, String message) {
    final m = Uint8List.fromList(message.codeUnits);
    int verifyResult = -1;
    final pkPtr = calloc<Uint8>(pk.length);
    final sigPtr = calloc<Uint8>(signtrList.length);
    final mPtr = calloc<Uint8>(m.length);

    final sigAllocator = bindings.sodiumMalloc(bindings.crypto_sign_BYTES());
    sigAllocator
        .asTypedList(bindings.crypto_sign_BYTES())
        .setAll(0, signtrList);
    final pkAllocator =
        bindings.sodiumMalloc(bindings.cryptoSignPublicKeyBytes());
    pkAllocator.asTypedList(bindings.cryptoSignPublicKeyBytes()).setAll(0, pk);
    pkPtr.asTypedList(pk.length).setAll(0, pk);
    sigPtr.asTypedList(signtrList.length).setAll(0, signtrList);
    mPtr.asTypedList(m.length).setAll(0, m);

    try {
      final verifyResult = bindings.cryptoSignVerifyDetached(
        sigAllocator,
        mPtr,
        m.length,
        pkAllocator,
      );

      return verifyResult;
    } catch (e) {
      print(e);
    } finally {
      calloc.free(mPtr);
      calloc.free(pkPtr);
      calloc.free(sigPtr);
      bindings.sodiumFree(sigAllocator);
      bindings.sodiumFree(pkAllocator);
    }
    return verifyResult;
  }
}

String getSodiumVersionString(final LibsodiumWrapper wrapper) =>
    wrapper.sodiumVersionString();

class CryptoSingCall {
  final LibsodiumWrapper wrapper;
  final Uint8List privateKeyList;
  final String message;

  CryptoSingCall(this.wrapper, this.privateKeyList, this.message);
}

class CryptoVerifySingCall {
  final LibsodiumWrapper wrapper;
  final Uint8List publicKeyList;
  final Uint8List signature;
  final String message;

  CryptoVerifySingCall(
      this.wrapper, this.publicKeyList, this.signature, this.message);
}

Uint8List? cryptoSignDetachedW(final CryptoSingCall call) =>
    call.wrapper.cryptoSignDetachedWrapping(call.privateKeyList, call.message);
int cryptoSignDetachedVerification(final CryptoVerifySingCall call) =>
    call.wrapper.cryptoSignDetachedWrappingVerification(
        call.publicKeyList, call.signature, call.message);
KeyPair getGeneratedKeyPair(final LibsodiumWrapper wrapper) {
  final keys = wrapper.generateKeyPair();
  return keys;
}

extension Uint8PointerExtensions on Pointer<Uint8> {
  Uint8List toList(int length) {
    final builder = BytesBuilder();
    for (int i = 0; i < length; i++) {
      builder.addByte(this[i]);
    }
    return builder.takeBytes();
  }
}

extension Uint8ListExtensions on Uint8List {
  Pointer<Uint8> toPointer() {
    if (this == null) {
      return Pointer<Uint8>.fromAddress(0);
    }
    final p = bindings.sodiumMalloc(this.length);
    final pList = p.asTypedList(this.length);
    pList.setAll(0, this);
    return p;
  }
}

extension StringExtensions on String {
  Pointer<Uint8> toUint8Pointer() {
    if (this == null) {
      return Pointer<Uint8>.fromAddress(0);
    }
    final units = utf8.encode(this);
    final Pointer<Uint8> result = bindings.sodiumMalloc(units.length);
    final Uint8List nativeString = result.asTypedList(units.length);
    nativeString.setAll(0, units);
    return result;
  }
}
