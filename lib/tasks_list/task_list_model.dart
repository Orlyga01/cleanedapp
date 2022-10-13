import 'dart:convert';

import 'package:cleanedapp/task/task_model.dart';
import 'package:sharedor/misc/model_class.dart';

class InsTaskList extends ModelClass {
  DateTime date;
  String ownerId;
  bool? latest;
  List<InsTask>? instTasks;

  InsTaskList({
    id,
    required this.date,
    required this.ownerId,
    this.latest,
    createdAt,
    modifiedAt,
  }) : super(id: id, createdAt: createdAt, modifiedAt: modifiedAt);
  InsTaskList.empty()
      : date = DateTime.now(),
        latest = true,
        ownerId = "",
        instTasks = [];

  factory InsTaskList.fromJ(Map<String, dynamic> mjson) {
    return InsTaskList.fromJson(mjson);
  }
  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['date'] = date;
    data['latest'] = latest;
    data['tasksJson'] = TaskListToJson(instTasks);
    return data;
  }

  String? TaskListToJson(List<InsTask>? tasks) {
    return (tasks != null && tasks.isNotEmpty)
        ? json.encode(tasks.map((InsTask) => InsTask.toJson()).toList(),
            toEncodable: myDateSerializer)
        : null;
  }

  InsTaskList.fromJson(Map<String, dynamic> mjson)
      : latest = false,
        date = DateTime.now(),
        ownerId = "" {
    super.fromJson(mjson);
    date = mjson['date'];
    latest = mjson['latest'];
    ownerId = mjson["ownerId"];
  }
}
