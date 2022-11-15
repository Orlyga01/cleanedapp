import 'dart:convert';
import 'dart:developer';

import 'package:cleanedapp/todo/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharedor/common_functions.dart';

class TodoListRepository {
  late String todoListid;
  late CollectionReference _todoListCollection;
  // ignore: unused_field
  late DocumentReference? _dbTaskList;
  static final TodoListRepository _dbTaskListRep =
      TodoListRepository._internal();
  TodoListRepository._internal();
  factory TodoListRepository({required String todoListid}) {
    _dbTaskListRep._todoListCollection =
        FirebaseFirestore.instance.collection("todolist");
    _dbTaskListRep.todoListid = todoListid;
    if (!todoListid.isEmptyBe) {
      _dbTaskListRep._dbTaskList =
          _dbTaskListRep._todoListCollection.doc(todoListid);
    }
    return _dbTaskListRep;
  }
  Future<TodoList?> add(TodoList todoList) async {
    // the todoList id will be the phone number
    try {
      await _todoListCollection.doc(todoList.id).set(todoList.toJson());

      return todoList;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> delete(String todoListid) {
    return _todoListCollection.doc(todoListid).delete();
  }

  Future<TodoList?> get(String? id) async {
    if (id == null || id.isEmpty) return null;
    print("ddd$id");
    try {
      DocumentSnapshot documentSnapshot =
          await _todoListCollection.doc(id).get();
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

  Future<void> update(String? id,
      [TodoList? todoList, String? fieldName, dynamic fieldValue]) {
    if (fieldName != null) {
      if (id == null) {
        log("----------error===========id was not passed to update");
        throw "no todoList id";
      }

      return _todoListCollection
          .doc(id)
          .update({fieldName: fieldValue, "modifiedAt": DateTime.now()});
    } else {
      if (todoList == null) {
        log("----------error===========no todoList");
        throw "no todoList ";
      }

      todoList.modifiedAt = DateTime.now();
      return _todoListCollection.doc(todoList.id).update(todoList.toJson());
    }
  }
}
