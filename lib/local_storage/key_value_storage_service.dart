import 'dart:convert';

import 'package:milkmatehub/models/supplier_model.dart';
import 'package:milkmatehub/models/user_model.dart';

import 'key_value_storage_base.dart';

/// A service class for providing methods to store and retrieve key-value data
/// from common or secure storage.
class CacheStorageService {
  /// The name of apns key
  static const _apnsKey = 'apns';

  /// The name of fcm key
  static const _fcmKey = 'fcm';

  /// The name of user key
  static const _userKey = 'user';

  /// Instance of key-value storage base class
  final _cacheStorage = CacheStorageBase.instance;

  /// Returns Registred FCM
  Future<String> getAPNS() async {
    return await _cacheStorage.getEncrypted(_apnsKey) ?? "";
  }

  /// Returns last authenticated user
  Future<dynamic> getAuthUser() async {
    final user = await _cacheStorage.getEncrypted(_userKey);
    if (user == null) return null;
    var decodedUser = jsonDecode(user);
  if(decodedUser['type'] == 'supplier'){
    return SupplierModel.fromJson(decodedUser);
  }
  else{
    return UserModel.fromJson(decodedUser);
  }
  }

  /// Returns Registred FCM
  Future<String> getFCM() async {
    return await _cacheStorage.getEncrypted(_fcmKey) ?? "";
  }

  Future resetKeys() async {
    await _cacheStorage.clearEncrypted();
  }

  Future setAPNS(String apns) async {
    await _cacheStorage.setEncrypted(_apnsKey, apns);
  }

  /// Sets the authenticated user to this value. Even though this method is
  /// asynchronous, we don't care about its completion which is why we don't
  /// use `await` and let it execute in the background.
  Future<bool> setAuthUser({UserModel? user, SupplierModel? supplier}) async {
    return await _cacheStorage.setEncrypted(
        _userKey,
        jsonEncode(user != null
            ? user.toJson()
            : supplier != null
                ? supplier.toJson()
                : {}));
  }

  /// Sets the FCM Token . Even though this method is
  /// asynchronous, we don't care about it's completion which is why we don't
  /// use `await` and let it execute in the background.
  Future setFCM(String fcm) async {
    await _cacheStorage.setEncrypted(_fcmKey, fcm);
  }

  /// Updates the user details with the provided user object.
  /// Even though this method is asynchronous, we don't care about its completion
  /// which is why we don't use `await` and let it execute in the background.
  // Future updateUserDetails(UserModel user) async {
  //   final userModel = await getAuthUser();
  //   if (userModel != null) {
  //     userModel.name = user.name;
  //     userModel.phoneNumber = user.phoneNumber;
  //     userModel.photoUrl = user.photoUrl;
  //     userModel.email = user.email;
  //     userModel.bloodType = user.bloodType;
  //     userModel.age = user.age;
  //     userModel.weight = user.weight;
  //     userModel.height = user.height;
  //     userModel.address = user.address;
  //     userModel.type = user.type;
  //     userModel.gender = user.gender;
  //     userModel.uid = user.uid;

  //     await _cacheStorage.setEncrypted(
  //         _userKey, jsonEncode(userModel.toJson()));
  //   }
  // }
}
