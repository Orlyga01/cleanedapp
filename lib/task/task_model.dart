import 'dart:convert';
import 'package:cleanedapp/misc/categories_mode.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/misc/model_class.dart';

class Task extends ModelClass<Task> {
  String title;
  List<String>? categories;
  String? description;
  String? img;
  FrequencyEnum frequency;
  bool? active;

  Task({
    id,
    required this.title,
    required this.frequency,
    this.categories,
    this.description,
    this.img,
    this.active = true,
    createdAt,
    modifiedAt,
  }) : super(id: id, createdAt: createdAt, modifiedAt: modifiedAt);
  static Task get empty => Task(title: "", frequency: FrequencyEnum.everyTime);
  bool get validate => !title.isEmptyBe;

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();

    data['title'] = title;
    data['description'] = description;
    data['img'] = img;
    data['categories'] = jsonEncode(categories);
    data['active'] = active;
    data['frequency'] = enumToString(frequency.toString());
    return data;
  }

  Task.fromJson(Map<String, dynamic> mjson)
      : title = mjson['title'],
        frequency = enumFromString<FrequencyEnum>(
                mjson['frequency'], FrequencyEnum.values) ??
            FrequencyEnum.everyTime,
        description = mjson['description'],
        categories = jsonDecode(mjson['categories']),
        active = mjson['active'] ?? true,
        img = mjson['img'] {
    super.fromJson(mjson);
  }
  List<Task>? listFromJson(List<dynamic>? list) {
    return (list != null && list.isNotEmpty)
        ? list.map((task) => Task.fromJson(task)).toList()
        : null;
  }
}

class ToDoTask extends ModelClass<ToDoTask> {
  String taskId;
  Task? task;
  bool active;
  bool complete;

  ToDoTask({
    required this.taskId,
    this.active = true,
    this.complete = false,
    id,
    createdAt,
    modifiedAt,
  }) : super(id: id, createdAt: createdAt, modifiedAt: modifiedAt);

  static ToDoTask get empty => ToDoTask(
        taskId: '',
        active: true,
        complete: false,
      );

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['taskId'] = taskId;
    data['active'] = active;
    data['complete'] = complete;
    return data;
  }

  @override
  ToDoTask.fromJson(Map<String, dynamic> mjson)
      : taskId = mjson['taskId'],
        active = mjson["active"],
        complete = mjson["complete"] {
    super.fromJson(mjson);
  }

  List<ToDoTask>? listFromJson(List<dynamic>? list) {
    return (list != null && list.isNotEmpty)
        ? list.map((user) => ToDoTask.fromJson(user)).toList()
        : null;
  }
}
