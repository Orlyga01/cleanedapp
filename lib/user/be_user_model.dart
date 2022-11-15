import 'package:cleanedapp/room/room_model.dart';
import 'package:cleanedapp/todo/todo_model.dart';
import 'package:sharedor/misc/model_class.dart';

class BeUser extends ModelClass<BeUser> {
  String? name;
  String phoneNo;
  List<Room> rooms;
  List<String>? listsid;

  BeUser({
    id,
    required this.phoneNo,
    this.name,
    required this.rooms,
    createdAt,
    modifiedAt,
  }) : super(id: id, createdAt: createdAt, modifiedAt: modifiedAt);
  static BeUser get empty {
    return BeUser(
        id: '', name: '', phoneNo: '', rooms: Room.getBasicRoomList());
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['name'] = name;
    data['phoneNo'] = phoneNo;
    data['rooms'] = listToJson(rooms);
    data['listsid'] = listsid?.join("@@");
    return data;
  }

  BeUser.fromJson(Map<String, dynamic> mjson)
      : name = '',
        phoneNo = '',
        rooms = [] {
    super.fromJson(mjson);
    name = mjson['name'];
    phoneNo = mjson['phoneNo'];
    listsid = (mjson['listsid'] == null || mjson['listsid'] == '')
        ? []
        : mjson['listsid'].split("@@");
    rooms = Room.empty.listFromJson(mjson['rooms']) ?? [];
  }

  factory BeUser.fromJ(Map<String, dynamic> mjson) {
    return BeUser.fromJson(mjson);
  }
  List<BeUser>? listFromJson(List<dynamic>? list) {
    return (list != null && list.isNotEmpty)
        ? list.map((user) => BeUser.fromJson(user)).toList()
        : null;
  }
  // BeUser.fromJson(Map<String, dynamic> mjson)
  //     : title = mjson['title'],
  //       roomNo = mjson['roomNo'],
  //       phoneNo = mjson['phoneNo'],
  //       description = mjson['description'],
  //       img = mjson['img'];
  // //   super.fromJson(mjson);
}
