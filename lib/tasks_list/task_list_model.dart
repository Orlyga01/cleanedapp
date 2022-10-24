import 'dart:convert';

import 'package:cleanedapp/task/task_model.dart';
import 'package:sharedor/misc/model_class.dart';

class TaskList extends ModelClass<TaskList> {
  List<Task> tasks;

  TaskList({
    id,
    required this.tasks,
    createdAt,
    modifiedAt,
  }) : super(id: id, createdAt: createdAt, modifiedAt: modifiedAt);
  // super.empty();
  static get empty {
    return TaskList(id: '', tasks: []);
  }

  factory TaskList.fromJ(Map<String, dynamic> mjson) {
    return TaskList.fromJson(mjson);
  }
  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['tasks'] = listToJson(tasks);
    return data;
  }

  TaskList.fromJson(Map<String, dynamic> mjson) : tasks = [] {
    super.fromJson(mjson);
    tasks = Task.empty.listFromJson(mjson['tasks']) ?? [];
  }
}
