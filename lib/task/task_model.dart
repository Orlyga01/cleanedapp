import 'dart:convert';
import 'package:cleanedapp/misc/categories_mode.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/misc/model_class.dart';

class Task extends ModelClass<Task> {
  String title;
  List<String>? categories;
  String? description;
  String? img;
  String? roomId;
  FrequencyEnum frequency;

  Task({
    id,
    required this.title,
    required this.frequency,
    this.categories,
    this.description,
    this.roomId,
    this.img,
    createdAt,
    modifiedAt,
  }) : super(id: id, createdAt: createdAt, modifiedAt: modifiedAt);
  static Task get empty =>
      Task(title: "", roomId: '', frequency: FrequencyEnum.everyTime);
  bool get validate => !title.isEmptyBe;

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();

    data['title'] = title;
    data['description'] = description;
    data['img'] = img;
    data['categories'] = jsonEncode(categories);
    data['roomId'] = roomId;
    data['frequency'] = enumToString(frequency.toString());
    return data;
  }

  Task.fromJson(Map<String, dynamic> mjson)
      : title = mjson['title'],
        roomId = mjson['room'],
        frequency = enumFromString<FrequencyEnum>(
                mjson['frequency'], FrequencyEnum.values) ??
            FrequencyEnum.everyTime,
        description = mjson['description'],
        categories = jsonDecode(mjson['categories']),
        img = mjson['img'] {
    super.fromJson(mjson);
  }
  List<Task>? listFromJson(List<dynamic>? list) {
    return (list != null && list.isNotEmpty)
        ? list.map((task) => Task.fromJson(task)).toList()
        : null;
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
    roomId,
    frequency,
  }) : super(title: title, roomId: roomId, frequency: frequency);
  static InsTask get empty => InsTask(
      listId: '',
      active: true,
      title: '',
      roomId: '',
      frequency: FrequencyEnum.everyTime);

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
