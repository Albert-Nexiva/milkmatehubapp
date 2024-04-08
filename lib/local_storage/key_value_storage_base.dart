import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Base class containing a unified API for key-value pairs' storage.
/// This class provides low level methods for storing:
/// - Sensitive keys using [FlutterSecureStorage]
/// - Insensitive keys using [SharedPreferences]
class CacheStorageBase {
  /// Instance of flutter secure storage
  static FlutterSecureStorage? _secureStorage;

  /// Singleton instance of KeyValueStorage Helper
  static CacheStorageBase? _instance;

  /// Get instance of this class
  static CacheStorageBase get instance =>
      _instance ?? const CacheStorageBase._();

  /// Private constructor
  const CacheStorageBase._();

  /// Erases encrypted keys
  Future<bool> clearEncrypted() async {
    try {
      await _secureStorage!.deleteAll();
      return true;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Reads the decrypted value for the key from secure storage
  Future<String?> getEncrypted(String key) {
    try {
      return _secureStorage!.read(key: key);
    } on PlatformException {
      return Future<String?>.value(null);
    }
  }

  /// Sets the encrypted value for the key to secure storage
  Future<bool> setEncrypted(String key, String value) {
    try {
      _secureStorage!.write(key: key, value: value);
      return Future.value(true);
    } on PlatformException catch (_) {
      return Future.value(false);
    }
  }

  /// Initializer for shared prefs and flutter secure storage
  /// Should be called in main before runApp and
  /// after WidgetsBinding.FlutterInitialized(), to allow for synchronous tasks
  /// when possible.
  static Future<void> init() async {
    _secureStorage ??= const FlutterSecureStorage();
  }
}
