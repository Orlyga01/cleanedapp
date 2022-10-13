import 'dart:convert';
import 'package:cleanedapp/misc/categories_mode.dart';
import 'package:sharedor/misc/model_class.dart';

class Task extends ModelClass {
  String title;
  List<String>? categories;
  String? description;
  String? img;
  List<String>? rooms;
  FrequencyEnum frequency;

  Task({
    id,
    required this.title,
    required this.frequency,
    this.categories,
    this.description,
    this.rooms,
    this.img,
    createdAt,
    modifiedAt,
  }) : super(id: id, createdAt: createdAt, modifiedAt: modifiedAt);

  Task.empty()
      : title = "",
        rooms = [],
        frequency = FrequencyEnum.everyTime;

// String? TaskToJson(Task task) {
//     return (task.isNotEmpty)
//         ? json.encode(task.map((Task) => Task.toJson()).toList(),
//             toEncodable: myDateSerializer)
//         : null;
//}
  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();

    data['title'] = title;
    data['description'] = description;
    data['img'] = img;
    data['categories'] = jsonEncode(categories);
    data['roomjson'] = rooms?.toList();
    data['frequency'] = frequency.index;
    return data;
  }

  Task.fromJson(Map<String, dynamic> mjson)
      : title = mjson['title'],
        rooms = mjson['rooms'],
        frequency = FrequencyEnum.values[mjson['frequency']],
        description = mjson['description'],
        categories = jsonDecode(mjson['categories']),
        img = mjson['img'] {
    super.fromJson(mjson);
  }
}

class InsTask extends Task {
  String listId;
  bool? active;

  InsTask({
    required this.listId,
    this.active = true,
    id,
    title,
    rooms,
    frequency,
  }) : super(title: title, rooms: rooms, frequency: frequency);
  InsTask.empty()
      : listId = "",
        active = true,
        super.empty();

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['listId'] = title;
    data['active'] = active;
    return data;
  }

  @override
  InsTask.fromJson(Map<String, dynamic> mjson)
      : listId = mjson['listId'],
        active = mjson["active"],
        super.fromJson(mjson);
}
