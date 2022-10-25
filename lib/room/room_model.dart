import 'dart:convert';
import 'package:cleanedapp/task/task_model.dart';
import 'package:cleanedapp/misc/categories_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/misc/model_class.dart';

class Room extends ModelClass<Room> {
  String title;
  RoomType? type;
  String? categoryJson;
  String? description;
  int? order;
  List<Task> roomTasks = [];

  Room({
    id,
    required this.roomTasks,
    this.order,
    required this.title,
    this.description,
    this.type,
    createdAt,
    modifiedAt,
  }) : super(id: id, createdAt: createdAt, modifiedAt: modifiedAt);

  static Room get empty => Room(
      id: '',
      title: 'Bedroom',
      type: RoomType.bedroom,
      order: 0,
      roomTasks: []);

  bool get validate => !title.isEmptyBe && type != null;

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['title'] = title;
    data['order'] = order;
    data['description'] = description;
    data['roomTasks'] = listToJson(roomTasks);

    data['type'] = enumToString(type.toString());

    return data;
  }

  Room.fromJson(Map<String, dynamic> mjson)
      : title = '',
        type = RoomType.bedroom,
        order = 0 {
    super.fromJson(mjson);
    title = mjson['title'];
    order = mjson['order'];
    description = mjson['description'];
    roomTasks = Task.empty.listFromJson(mjson['roomTasks']) ?? [];

    type = enumFromString(mjson['type'], RoomType.values) ?? RoomType.bathroom;
  }

  factory Room.fromJ(Map<String, dynamic> mjson) {
    return Room.fromJson(mjson);
  }

  List<Room>? listFromJson(List<dynamic>? list) {
    return (list != null && list.isNotEmpty)
        ? list.map((task) => Room.fromJson(task)).toList()
        : null;
  }

  static List<Room> getBasicRoomList({int priority = 5}) {
    List<Room> rooms = [];
    for (var element in RoomType.values) {
      int? imp = RoomTypes[element]!.importance;
      if (imp != null && imp > priority) {
        rooms.add(
          Room.empty
            ..type = element
            ..roomTasks = initialTaskList[element]!
            ..title = RoomTypes[element]!.name!,
        );
      }
    }
    return rooms;
  }
}

enum RoomType {
  kitchen,
  livingRoom,
  diningRoom,
  bathroom,
  masterBedroom,
  bedroom,
  studyRoom,
  familyRoom,
  laundryRoom
}

class GenericInfoEnum {
  final String? name;
  final String? img;
  final IconData? icon;
  final bool? singleton;
  final int? importance;
  GenericInfoEnum(
      {this.importance,
      this.name,
      this.singleton = false,
      this.img,
      this.icon});
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

// ignore: non_constant_identifier_names
Map<RoomType, GenericInfoEnum> RoomTypes = {
  RoomType.bathroom: GenericInfoEnum(
    name: enumToString(RoomType.bathroom.toString()),
    icon: LineAwesomeIcons.bath,
    importance: 10,
  ),
  RoomType.bedroom: GenericInfoEnum(
      name: enumToString(RoomType.bedroom.toString()),
      icon: LineAwesomeIcons.bed,
      importance: 10),
  RoomType.masterBedroom: GenericInfoEnum(
      name: enumToString(RoomType.masterBedroom.toString()),
      icon: LineAwesomeIcons.bed,
      importance: 10),
  RoomType.kitchen: GenericInfoEnum(
      name: enumToString(RoomType.kitchen.toString()),
      icon: LineAwesomeIcons.utensils,
      importance: 10),
  RoomType.diningRoom: GenericInfoEnum(
    name: enumToString(RoomType.diningRoom.toString()),
    icon: LineAwesomeIcons.utensils,
  ),
  RoomType.studyRoom: GenericInfoEnum(
    name: enumToString(RoomType.studyRoom.toString()),
    icon: LineAwesomeIcons.print,
  ),
  RoomType.livingRoom: GenericInfoEnum(
      name: enumToString(RoomType.livingRoom.toString()),
      icon: LineAwesomeIcons.couch,
      importance: 10),
  RoomType.familyRoom: GenericInfoEnum(
    name: enumToString(RoomType.familyRoom.toString()),
    icon: LineAwesomeIcons.couch,
  ),
  RoomType.laundryRoom: GenericInfoEnum(
    name: enumToString(RoomType.laundryRoom.toString()),
    icon: LineAwesomeIcons.cotton_bureau,
  ),
};
List<Room> testRooms = [
  Room.empty
    ..type = RoomType.kitchen
    ..roomTasks = initialTaskList[RoomType.kitchen]!
    ..title = RoomTypes[RoomType.kitchen]!.name!,
  Room.empty
    ..type = RoomType.livingRoom
    ..roomTasks = initialTaskList[RoomType.livingRoom]!
    ..title = RoomTypes[RoomType.livingRoom]!.name!,
  Room.empty
    ..type = RoomType.masterBedroom
    ..roomTasks = initialTaskList[RoomType.masterBedroom]!
    ..title = RoomTypes[RoomType.masterBedroom]!.name!,
  Room.empty
    ..type = RoomType.bathroom
    ..roomTasks = initialTaskList[RoomType.bathroom]!
    ..title = RoomTypes[RoomType.bathroom]!.name!,
  Room.empty
    ..type = RoomType.studyRoom
    ..roomTasks = initialTaskList[RoomType.studyRoom]!
    ..title = RoomTypes[RoomType.studyRoom]!.name!,
];
Map<RoomType, List<Task>> initialTaskList = {
  RoomType.bathroom: [
    Task(
        title: "Mirrors", frequency: FrequencyEnum.everyTime, id: generateId()),
    Task(
        title: "Toilet Seat",
        frequency: FrequencyEnum.everyTime,
        id: generateId()),
    Task(title: "Floor", frequency: FrequencyEnum.everyTime, id: generateId()),
    Task(
        title: "Shower inside",
        frequency: FrequencyEnum.everyTime,
        id: generateId()),
    Task(
        title: "Glass doors", frequency: FrequencyEnum.month, id: generateId()),
    Task(title: "Sink", frequency: FrequencyEnum.month, id: generateId()),
  ],
  RoomType.bedroom: basicAllRooms +
      [
        Task(
            title: "Change Sheets",
            frequency: FrequencyEnum.everySecondTime,
            id: generateId()),
      ],
  RoomType.masterBedroom: basicAllRooms +
      [
        Task(
            title: "Change Sheets",
            frequency: FrequencyEnum.everySecondTime,
            id: generateId()),
      ],
  RoomType.kitchen: basicAllRooms +
      [
        Task(
            title: "Sink",
            frequency: FrequencyEnum.everyTime,
            id: generateId()),
        Task(
            title: "Electric instument on the counter",
            frequency: FrequencyEnum.everyTime,
            id: generateId()),
        Task(
            title: "Microwave and oven",
            frequency: FrequencyEnum.everyTime,
            id: generateId()),
        Task(
            title: "Drawers", frequency: FrequencyEnum.month, id: generateId()),
      ],
  RoomType.diningRoom: basicAllRooms,
  RoomType.studyRoom: basicAllRooms,
  RoomType.livingRoom: basicAllRooms,
  RoomType.familyRoom: basicAllRooms,
  RoomType.laundryRoom: basicAllRooms
};
List<Task> basicAllRooms = [
  Task(title: "Windows", frequency: FrequencyEnum.month, id: generateId()),
  Task(
      title: "Aircondition filter",
      frequency: FrequencyEnum.halfAYear,
      id: generateId()),
  Task(title: "Floor", frequency: FrequencyEnum.everyTime, id: generateId()),
  Task(
      title: "Electric shulters",
      frequency: FrequencyEnum.halfAYear,
      id: generateId()),
];
