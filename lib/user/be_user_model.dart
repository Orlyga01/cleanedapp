import 'package:cleanedapp/room/room_model.dart';
import 'package:cleanedapp/todo/todo_model.dart';
import 'package:sharedor/misc/model_class.dart';

class BeUser extends ModelClass<BeUser> {
  String? name;
  String phoneNo;
  List<Room> rooms;
  List<TaskList>? lists;

  BeUser({
    id,
    required this.phoneNo,
    this.name,
    required this.rooms,
    this.lists,
    createdAt,
    modifiedAt,
  }) : super(id: id, createdAt: createdAt, modifiedAt: modifiedAt);
  static get empty {
    return BeUser(
        id: '', name: '', phoneNo: '', rooms: Room.getBasicRoomList());
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['name'] = name;
    data['phoneNo'] = phoneNo;
    data['rooms'] = listToJson(rooms);
    return data;
  }

  BeUser.fromJson(Map<String, dynamic> mjson)
      : name = '',
        phoneNo = '',
        rooms = [] {
    super.fromJson(mjson);
    name = mjson['name'];
    phoneNo = mjson['phoneNo'];
    rooms = Room.empty.listFromJson(mjson['rooms']) ?? [];
  }

  factory BeUser.fromJ(Map<String, dynamic> mjson) {
    return BeUser.fromJson(mjson);
  }

  // BeUser.fromJson(Map<String, dynamic> mjson)
  //     : title = mjson['title'],
  //       roomNo = mjson['roomNo'],
  //       phoneNo = mjson['phoneNo'],
  //       description = mjson['description'],
  //       img = mjson['img'];
  // //   super.fromJson(mjson);
}
