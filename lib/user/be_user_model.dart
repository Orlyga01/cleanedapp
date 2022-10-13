import 'dart:convert';
import 'package:authentication/authentication.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/misc/model_class.dart';

class BeUser extends AuthUser {
  String? title;
  String roomNo;
  String? categoryJson;
  String? description;
  String? img;
  int? order;

  BeUser({
    id,
    order,
    required this.roomNo,
    this.title,
    this.description,
    this.img,
    createdAt,
    modifiedAt,
  }) : super(id: id, createdAt: createdAt, modifiedAt: modifiedAt);
  get empty {
    return BeUser(
      id: '',
      title: '',
      roomNo: '0',
    );
  }

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
        'img': img,
        'createdAt': createdAt?.millisecondsSinceEpoch,
        'modifiedAt': modifiedAt?.millisecondsSinceEpoch,
      };
  // BeUser.fromJson(Map<String, dynamic> mjson)
  //     : title = mjson['title'],
  //       roomNo = mjson['roomNo'],
  //       order = mjson['order'],
  //       description = mjson['description'],
  //       img = mjson['img'];
  // //   super.fromJson(mjson);
}
