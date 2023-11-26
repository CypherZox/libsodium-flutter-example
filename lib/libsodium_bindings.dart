library bindings;

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

final libsodium = _load();

DynamicLibrary _load() {
  if (Platform.isAndroid) {
    return DynamicLibrary.open("libsodium.so");
  } else {
    return DynamicLibrary.process();
  }
}

// https://doc.libsodium.org/quickstart#boilerplate
// https://github.com/jedisct1/libsodium/blob/2d5b954/src/libsodium/sodium/core.c#L27-L53
typedef NativeInit = Int32 Function();
typedef Init = int Function();
final Init sodiumInit =
    libsodium.lookupFunction<NativeInit, Init>('sodium_init');

// https://github.com/jedisct1/libsodium/blob/927dfe8/src/libsodium/sodium/version.c#L4-L8
typedef NativeVersionString = Pointer<Utf8> Function();
typedef VersionString = Pointer<Utf8> Function();
final VersionString sodiumVersionString =
    libsodium.lookupFunction<NativeVersionString, VersionString>(
        'sodium_version_string');
// libsodium uses canary pages, guard pages, memory locking, and fills malloc'd memory with a
// specific byte pattern [1]. Whenever allocating memory in order to interact with libsodium
// we prefer to use libsodium's sodium_malloc and sodium_free.
//
// [1] https://doc.libsodium.org/memory_management

typedef NativeReturnSizeT = IntPtr Function();

final int Function() crypto_sign_BYTES = libsodium
    .lookup<NativeFunction<NativeReturnSizeT>>('crypto_sign_bytes')
    .asFunction();
final int Function() cryptoSignSecretKeyBytes = libsodium
    .lookup<NativeFunction<NativeReturnSizeT>>('crypto_sign_secretkeybytes')
    .asFunction();
final int Function() cryptoSignPublicKeyBytes = libsodium
    .lookup<NativeFunction<NativeReturnSizeT>>('crypto_sign_publickeybytes')
    .asFunction();
//crypto_sign_secretkeybytes
//crypto_sign_publickeybytes
typedef Malloc = Pointer<Uint8> Function(int size);
typedef NativeMalloc = Pointer<Uint8> Function(IntPtr size);
final Malloc sodiumMalloc =
    libsodium.lookupFunction<NativeMalloc, Malloc>('sodium_malloc');

typedef Malloc64 = Pointer<Uint64> Function(int size);
typedef NativeMalloc64 = Pointer<Uint64> Function(IntPtr size);
final Malloc64 sodiumMalloc64 =
    libsodium.lookupFunction<NativeMalloc64, Malloc64>('sodium_malloc');

typedef Free = void Function(Pointer<Uint8> ptr);
typedef NativeFree = Void Function(Pointer<Uint8> ptr);
final Free sodiumFree =
    libsodium.lookupFunction<NativeFree, Free>('sodium_free');

typedef Free64 = void Function(Pointer<Uint64> ptr);
typedef NativeFree64 = Void Function(Pointer<Uint64> ptr);
final Free64 sodiumFree64 =
    libsodium.lookupFunction<NativeFree64, Free64>('sodium_free');

typedef CryptoBoxKeypair = int Function(Pointer<Uint8> pk, Pointer<Uint8> sk);
typedef NativeCryptoBoxKeypair = Int32 Function(
    Pointer<Uint8> pk, Pointer<Uint8> sk);

final CryptoBoxKeypair cryptoBoxKeypair =
    libsodium.lookupFunction<NativeCryptoBoxKeypair, CryptoBoxKeypair>(
        'crypto_box_keypair');

typedef CryptoSingKeypair = int Function(Pointer<Uint8> pk, Pointer<Uint8> sk);
typedef NativeCryptoSingKeypair = Int32 Function(
    Pointer<Uint8> pk, Pointer<Uint8> sk);

final CryptoSingKeypair cryptoSignKeypair =
    libsodium.lookupFunction<NativeCryptoSingKeypair, CryptoSingKeypair>(
        'crypto_sign_keypair');

// crypto_box_seal(ciphertext, MESSAGE, MESSAGE_LEN, recipient_pk);
typedef CryptoBoxSeal = int Function(
    Pointer<Uint8> c, Pointer<Uint8> m, int mlen, Pointer<Uint8> pk);
typedef NativeCryptoBoxSeal = Int32 Function(
    Pointer<Uint8> c, Pointer<Uint8> m, Uint64 mlen, Pointer<Uint8> pk);
final CryptoBoxSeal cryptoBoxSeal = libsodium
    .lookupFunction<NativeCryptoBoxSeal, CryptoBoxSeal>('crypto_box_seal');

int cryptoSignDetached(
  Pointer<Uint8> sig,
  Pointer<Uint64> siglen,
  Pointer<Uint8> m,
  int mlen,
  Pointer<Uint8> sk,
) {
  try {
    return libsodium.lookupFunction<
        Int32 Function(Pointer<Uint8>, Pointer<Uint64>, Pointer<Uint8>, Uint64,
            Pointer<Uint8>),
        int Function(Pointer<Uint8>, Pointer<Uint64>, Pointer<Uint8>, int,
            Pointer<Uint8>)>(
      'crypto_sign_detached',
    )(sig, siglen, m, mlen, sk);
  } catch (e) {
    return -1;
  }
}

int cryptoSignVerifyDetached(
  Pointer<Uint8> sig,
  Pointer<Uint8> m,
  int mlen,
  Pointer<Uint8> pk,
) {
  return libsodium.lookupFunction<
      Int32 Function(Pointer<Uint8>, Pointer<Uint8>, Uint64, Pointer<Uint8>),
      int Function(Pointer<Uint8>, Pointer<Uint8>, int, Pointer<Uint8>)>(
    'crypto_sign_verify_detached',
  )(sig, m, mlen, pk);
}
