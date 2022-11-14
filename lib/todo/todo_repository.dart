import 'dart:convert';
import 'dart:developer';

import 'package:cleanedapp/todo/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharedor/common_functions.dart';

class FirebaseTaskListRepository {
  late String taskListid;
  late CollectionReference _taskListCollection;
  // ignore: unused_field
  late DocumentReference? _dbTaskList;
  static final FirebaseTaskListRepository _dbTaskListRep =
      FirebaseTaskListRepository._internal();
  FirebaseTaskListRepository._internal();
  factory FirebaseTaskListRepository({required String taskListid}) {
    _dbTaskListRep._taskListCollection =
        FirebaseFirestore.instance.collection("tasklists");
    _dbTaskListRep.taskListid = taskListid;
    if (!taskListid.isEmptyBe) {
      _dbTaskListRep._dbTaskList =
          _dbTaskListRep._taskListCollection.doc(taskListid);
    }
    return _dbTaskListRep;
  }
  Future<TodoList?> add(TodoList taskList) async {
    // the taskList id will be the phone number
    try {
      await _taskListCollection.doc(taskList.id).set(taskList.toJson());
      setTaskListId = taskList.id;

      return taskList;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> delete(String taskListid) {
    return _taskListCollection.doc(taskListid).delete();
  }

  Future<TodoList?> get({String? id}) async {
    if (id == null && taskListid.isEmptyBe) {
      log("no taskList id provided");
      throw "error";
    }
    id = id ?? taskListid;

    try {
      DocumentSnapshot documentSnapshot =
          await _taskListCollection.doc(id).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        data['id'] = id;
        return TodoList.fromJson(data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  set setTaskListId(String value) {
    taskListid = value;
    if (!value.isEmptyBe) {
      _dbTaskList = _taskListCollection.doc(value);
    }
  }

  Future<void> update(String? id,
      [TodoList? taskList, String? fieldName, dynamic fieldValue]) {
    if (fieldName != null) {
      if (id == null) {
        log("----------error===========id was not passed to update");
        throw "no taskList id";
      }

      return _taskListCollection
          .doc(id)
          .update({fieldName: fieldValue, "modifiedAt": DateTime.now()});
    } else {
      if (taskList == null) {
        log("----------error===========no taskList");
        throw "no taskList ";
      }

      taskList.modifiedAt = DateTime.now();
      return _taskListCollection.doc(taskList.id).update(taskList.toJson());
    }
  }
}
