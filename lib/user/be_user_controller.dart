import 'dart:async';
import 'package:cleanedapp/helpers/local_storage.dart';
import 'package:cleanedapp/user/be_user_model.dart';
import 'package:cleanedapp/user/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharedor/helpers/export_helpers.dart';

class BeUserController {
  static final BeUserController _beUserC = new BeUserController._internal();
  late FirebaseUserRepository _beUserRepository;
  BeUserController._internal();
  BeUser _beUser = BeUser.empty;
  factory BeUserController() {
    _beUserC._beUserRepository = FirebaseUserRepository(userid: '');
    return _beUserC;
  }
  void init() async {
    BeUser? beUser = getOfflineUser();
    _beUser = beUser ?? BeUser.empty
      ..id = "";
    _beUserRepository.setUserId = user.id;
  }

  Future<BeUser?> get(String id) async {
    id = id.replaceAll(RegExp(r'[^0-9]'), '');
    return _beUserRepository.get(id: id);
  }

  void setOfflineUser(BeUser user) {
    PreferenceUtils().mapToStorage("cleanapp_user", user.toJson());
  }

  BeUser? getOfflineUser() {
    Map<String, dynamic>? userJson =
        PreferenceUtils().storageToMap("cleanapp_user");
    if (userJson != null) {
      return BeUser.fromJson(userJson);
    }
  }

  String get userid => _beUser.id;

  BeUser get user => _beUser;

  Future<void> resetBeUser() async {
    _beUser = BeUser.empty;
  }

  Future<BeUser?> add(
    BeUser beUser,
  ) async {
    BeUser? returnBeUser;
    beUser.id = beUser.phoneNo.replaceAll(RegExp(r'[^0-9]'), '');
    try {
      returnBeUser = await _beUserRepository.add(beUser);
      _beUser = returnBeUser ?? beUser;
      if (returnBeUser != null) {
        setOfflineUser(returnBeUser);
      }
      return (returnBeUser != null) ? returnBeUser : null;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> updateBeUser(String id,
      [BeUser? user, String? fieldName, dynamic fieldValue]) async {
    if (fieldName != null) {
      _beUser.toJson()[fieldName] = fieldValue;
    } else
      _beUser = user!;
    try {
      _beUserRepository.update(id, user, fieldName, fieldValue);
      setOfflineUser(_beUser);
    } catch (e) {
      throw e.toString();
    }
  }
}
