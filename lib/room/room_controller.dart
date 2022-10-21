import 'dart:async';

import 'package:cleanedapp/Task/task_model.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomController {
  static final RoomController _roomC =  RoomController._internal();
  // FirebaseMeetingRepository _meetingRepository = FirebaseMeetingRepository();

  RoomController._internal();
  factory RoomController() {
    return _roomC;
  }
  final listRoom = StreamController<List<Room>>();
  Stream<List<Room>> get getRooms => listRoom.stream;
  List<Room> _list = Room.getBasicRoomList();

  void setCurrentRoomList(List<Room> list) {
    _list = list;
    listRoom.add(_list);
  }

  // Future<void> saveRoom() async {
  //   final menu = locator.get<UserListController>().menu;
  //   try {
  //     locator.get<FamilyController>().updateFamily(
  //         fieldName: "menuJson", fieldValue: Room.toJson(menu));
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  void dispose() {
    listRoom.close();
  }

  Future<void> updateRooms(List<Room> list) async {
    //Do update menu then sink
    // we want that new or recently updated would always be the first in the list
    _list = list;
    listRoom.sink.add(_list);
  }

  List<Task> getTaskByRoom(String room) {
    return [];
  }
}

final streamUserRooms = StreamProvider.autoDispose<List<Room>>((ref) {
  ref.onDispose(() => print("controller for uid was disposed"));

  return RoomController().getRooms;
});
