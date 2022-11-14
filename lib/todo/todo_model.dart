import 'dart:convert';

import 'package:cleanedapp/room/room_model.dart';
import 'package:cleanedapp/task/task_model.dart';
import 'package:cleanedapp/user/be_user_model.dart';
import 'package:sharedor/misc/model_class.dart';

class TodoList extends ModelClass<TodoList> {
  List<ToDoRoom> tasks;
  String userid;
  String cleanerid;
  String title;
  TodoList({
    id,
    required this.tasks,
    required this.userid,
    required this.cleanerid,
    required this.title,
    createdAt,
    modifiedAt,
  }) : super(id: id, createdAt: createdAt, modifiedAt: modifiedAt);
  // super.empty();
  static get empty {
    return TodoList(id: '', title: '', cleanerid: '', userid: '', tasks: []);
  }

  factory TodoList.fromJ(Map<String, dynamic> mjson) {
    return TodoList.fromJson(mjson);
  }
  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['tasks'] = listToJson(tasks);
    data['cleanerid'] = cleanerid;
    data['userid'] = userid;
    data['title'] = title;
    return data;
  }

  Map<Room, List<Task>> roomtasksFromJson(
      Map<Map<String, dynamic>, List<Map<String, dynamic>>> tasks) {
    return tasks.map(
        (Map<String, dynamic> key, List<Map<String, dynamic>> tasks) =>
            MapEntry(Room.fromJson(key), Task.empty.listFromJson(tasks)!));
  }

  TodoList.fromJson(Map<String, dynamic> mjson)
      : tasks = [],
        cleanerid = mjson['cleanerid'],
        title = mjson['title'],
        userid = mjson['userid'] {
    super.fromJson(mjson);
    tasks = ToDoRoom.empty.listFromJson(mjson['tasks']) ?? [];
  }
}

class ToDoRoom extends ModelClass<ToDoRoom> {
  String roomId;
  bool active;
  bool complete;
  List<ToDoTask> tasks;

  ToDoRoom({
    required this.roomId,
    required this.tasks,
    this.active = true,
    this.complete = false,
    id,
    createdAt,
    modifiedAt,
  }) : super(id: id, createdAt: createdAt, modifiedAt: modifiedAt);

  static ToDoRoom get empty =>
      ToDoRoom(roomId: '', active: true, complete: false, tasks: []);

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['roomId'] = roomId;
    data['active'] = active;
    data['complete'] = complete;
    data['tasks'] = listToJson(tasks);
    return data;
  }

  @override
  ToDoRoom.fromJson(Map<String, dynamic> mjson)
      : roomId = mjson['roomId'],
        active = mjson["active"],
        tasks = ToDoTask.empty.listFromJson(mjson['tasks']) ?? [],
        complete = mjson["complete"] {
    super.fromJson(mjson);
  }
  List<ToDoRoom>? listFromJson(List<dynamic>? list) {
    return (list != null && list.isNotEmpty)
        ? list.map((user) => ToDoRoom.fromJson(user)).toList()
        : null;
  }
}
