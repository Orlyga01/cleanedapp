import 'dart:async';
import 'dart:developer';

import 'package:cleanedapp/room/room_controller.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:cleanedapp/task/task_model.dart';
import 'package:cleanedapp/todo/todo_model.dart';
import 'package:cleanedapp/user/be_user_model.dart';
import 'package:cleanedapp/user/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

//------------------Lists-------------------------
  TodoList? getTaskListById(String? listId) {
    if (user.lists == null) {
      print("user lists is still empty");
      throw "user lists is still empty";
    }
    if (listId == null) {
      return user.lists![0];
    } else {
      return user.lists!.firstWhere((element) => element.id == listId);
    }
  }

  int createList({String origin = "prev"}) {
    switch (origin) {
      case "prev":
        if (user.lists == null) {
          user.lists = [
            TodoList(
                tasks: convertToInstance(testRooms),
                userid: userid,
                cleanerid: '',
                title: "Tasks For")
          ];
          return 0;
        } else {
          user.lists!.insert(
              0,
              TodoList(
                  tasks: clone(user.lists![0].tasks),
                  userid: userid,
                  cleanerid: user.lists![0].cleanerid,
                  title: "title"));
        }
        break;
      default:
    }
    return 0;
  }

  TodoList? get latestList {
    // ignore: prefer_is_empty
    if (_beUser.lists == null || _beUser.lists!.length == 0) {
      return null;
    } else {
      return _beUser.lists![0];
    }
  }

  List<ToDoRoom> clone(List<ToDoRoom> rooms) {
    List<ToDoRoom> todoList = [];
    for (ToDoRoom room in rooms) {
      todoList.add(
        ToDoRoom.empty
          ..roomId = room.id
          ..active = room.active,
      );
      for (ToDoTask task in room.tasks) {
        todoList[todoList.length - 1].tasks.add(ToDoTask.empty
          ..taskId = task.id
          ..active = task.active);
      }
    }
    return todoList;
  }

  List<ToDoRoom> convertToInstance(List<Room> rooms) {
    List<ToDoRoom> todoList = [];
    for (Room room in rooms) {
      todoList.add(
        ToDoRoom.empty..roomId = room.id,
      );
      for (Task task in room.roomTasks) {
        todoList[todoList.length - 1]
            .tasks
            .add(ToDoTask.empty..taskId = task.id);
      }
    }
    return todoList;
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

  Future<void> updateRoomOfUser(
    Room room,
  ) async {
    if (!room.validate) throw "room not valid";
    final index = user.rooms.indexWhere((element) => element.id == room.id);
    if (index >= 0) {
      user.rooms[index] = room;
    } else {
      user.rooms = [room] + user.rooms;
    }
    try {
      await updateRoomListOfUser(user.rooms);
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

  ///-------Tasks------

  Future<void> updateTaskOfRoom(Room room, Task task) async {
    if (!task.validate) throw "task not valid";
    final index = room.roomTasks.indexWhere((element) => element.id == task.id);
    if (index >= 0) {
      room.roomTasks[index] = task;
    } else {
      room.roomTasks = [task] + room.roomTasks;
    }
    try {
      await updateRoomOfUser(room);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateListTaskOfRoom(Room room, List<Task> tasks) async {
    room.roomTasks = tasks;

    return await updateRoomOfUser(room);
  }

  Future<void> deleteRoomTask(Room room, Task task) async {
    final index = room.roomTasks.indexWhere((element) => element.id == task.id);
    if (index > -1) {
      try {
        room.roomTasks.removeAt(index);
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
