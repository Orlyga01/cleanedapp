import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/misc/model_class.dart';

class Room extends ModelClass {
  String? title;
  String roomNo;
  RoomType? type;
  String? categoryJson;
  String? description;
  int? order;

  Room({
    id,
    this.order,
    required this.roomNo,
    this.title,
    this.description,
    this.type,
    createdAt,
    modifiedAt,
  }) : super(id: id, createdAt: createdAt, modifiedAt: modifiedAt);
  @override
  static Room get empty =>
      Room(id: '', title: '', roomNo: '0', type: RoomType.bedroom, order: 0);

  dynamic myDateSerializer(dynamic object) {
    if (object is DateTime) {
      return object.toIso8601String();
    }
    return object;
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'order': order,
        'roomNo': roomNo,
        'description': description,
        'type': enumToString(type.toString()),
        'createdAt': createdAt.millisecondsSinceEpoch,
        'modifiedAt': modifiedAt.millisecondsSinceEpoch,
      };
  Room.fromJson(Map<String, dynamic> mjson)
      : title = '',
        roomNo = '0',
        type = RoomType.bedroom,
        order = 0 {
    super.fromJson(mjson);
    title = mjson['title'];
    roomNo = mjson['roomNo'];
    order = mjson['order'];
    description = mjson['description'];
    type = enumFromString(mjson['type'], RoomType.values) ?? RoomType.bathroom;
  }

  factory Room.fromJ(Map<String, dynamic> mjson) {
    return Room.fromJson(mjson);
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
  GenericInfoEnum({this.name, this.singleton = false, this.img, this.icon});
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
  ),
  RoomType.bedroom: GenericInfoEnum(
    name: enumToString(RoomType.bedroom.toString()),
    icon: LineAwesomeIcons.bed,
  ),
  RoomType.masterBedroom: GenericInfoEnum(
    name: enumToString(RoomType.masterBedroom.toString()),
    icon: LineAwesomeIcons.bed,
  ),
  RoomType.kitchen: GenericInfoEnum(
    name: enumToString(RoomType.kitchen.toString()),
    icon: LineAwesomeIcons.utensils,
  ),
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
  ),
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
    ..title = RoomTypes[RoomType.kitchen]!.name,
  Room.empty
    ..type = RoomType.livingRoom
    ..title = RoomTypes[RoomType.livingRoom]!.name,
  Room.empty
    ..type = RoomType.masterBedroom
    ..title = RoomTypes[RoomType.masterBedroom]!.name,
  Room.empty
    ..type = RoomType.bathroom
    ..title = RoomTypes[RoomType.bathroom]!.name,
  Room.empty
    ..type = RoomType.studyRoom
    ..title = RoomTypes[RoomType.studyRoom]!.name,
];
