import 'dart:async';
import 'dart:developer';

import 'package:cleanedapp/room/room_controller.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:cleanedapp/user/be_user_model.dart';
import 'package:cleanedapp/user/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharedor/helpers/export_helpers.dart';

class BeUserController {
  static final BeUserController _beUserC = BeUserController._internal();
  late FirebaseUserRepository _beUserRepository;
  BeUserController._internal();
  BeUser _beUser = BeUser.empty;
  factory BeUserController() {
    _beUserC._beUserRepository = FirebaseUserRepository(userid: '');
    return _beUserC;
  }
  void init() async {
    BeUser? beUser = getOfflineUser();
    _beUser = beUser ?? BeUser.empty;

    setUser(_beUser);
  }

  setUser(BeUser user) {
    _beUser = user;
    _beUserRepository.setUserId = _beUser.id;
    // _beUser.rooms.removeRange(5, _beUser.rooms.length);

    // updateBeUser(user.id,
    //     fieldName: "rooms", fieldValue: user.listToJson(_beUser.rooms));
    RoomController().setCurrentRoomList(_beUser.rooms);

    setOfflineUser(user);
  }

  clearUser() {
    _beUser = BeUser.empty;
    PreferenceUtils().clear("cleanapp_user");
  }

  Future<BeUser?> get(String id, {bool setInit = false}) async {
    id = id.replaceAll(RegExp(r'[^0-9]'), '');
    try {
      BeUser? user = await _beUserRepository.get(id: id);
      if (user != null) {
        setUser(user);
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }

  void setOfflineUser(BeUser user) {
    PreferenceUtils().mapToStorage("cleanapp_user", user.toJson());
  }

  BeUser? getOfflineUser() {
    // PreferenceUtils().clear("cleanapp_user");
    Map<String, dynamic>? userJson =
        PreferenceUtils().storageToMap("cleanapp_user");
    if (userJson != null) {
      userJson['createdAt'] = DateTime.tryParse(userJson['createdAt']);
      userJson['modifiedAt'] = DateTime.tryParse(userJson['modifiedAt']);

      return BeUser.fromJson(userJson);
    }
    return null;
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
      {BeUser? user, String? fieldName, dynamic fieldValue}) async {
    if (fieldName != null) {
      _beUser.toJson()[fieldName] = fieldValue;
    } else {
      _beUser = user!;
    }
    try {
      await _beUserRepository.update(id, user, fieldName, fieldValue);
      setOfflineUser(_beUser);
    } catch (e) {
      throw e.toString();
    }
  }

//------------------------Rooms--------------------
  Future<void> updateRoomListOfUser(
    List<Room> rooms,
  ) async {
    try {
      await updateBeUser(userid,
          fieldName: "rooms", fieldValue: user.listToJson(rooms));

      RoomController().updateRooms(user.rooms);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateRoomOfUser(Room room, {addMode = false}) async {
    if (!room.validate) throw "room not valid";
    final index = user.rooms.indexWhere((element) => element.id == room.id);
    if (index >= 0) {
      user.rooms[index] = room;
    } else {
      user.rooms = [room] + user.rooms;
    }
    try {
      await updateBeUser(userid,
          fieldName: "rooms", fieldValue: user.listToJson(user.rooms));
      RoomController().updateRooms(user.rooms);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserRoom(Room room) async {
    int index = user.rooms.indexWhere((element) => element.id == room.id);
    if (index > -1) {
      try {
        user.rooms.removeAt(index);
        await BeUserController().updateRoomListOfUser(user.rooms);
      } catch (e) {
        rethrow;
      }
    } else {
      log("room with id $room.id cannot be found");
      throw "error";
    }
  }
}
