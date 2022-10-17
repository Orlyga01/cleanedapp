import 'dart:convert';

import 'package:cleanedapp/task/task_model.dart';
import 'package:sharedor/misc/model_class.dart';

class TaskList extends ModelClass {
  DateTime date;
  List<Task> tasks;

  TaskList({
    id,
    required this.date,
    required this.tasks,
    createdAt,
    modifiedAt,
  }) : super(id: id, createdAt: createdAt, modifiedAt: modifiedAt);
  TaskList.empty()
      : date = DateTime.now(),
        tasks = [];
  // super.empty();

  factory TaskList.fromJ(Map<String, dynamic> mjson) {
    return TaskList.fromJson(mjson);
  }
  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['date'] = date;
    data['tasks'] = listToJson(tasks);
    return data;
  }

  TaskList.fromJson(Map<String, dynamic> mjson)
      : date = DateTime.now(),
        tasks = [] {
    super.fromJson(mjson);
    date = mjson['date'];
    tasks = mjson['task'];
  }
}
