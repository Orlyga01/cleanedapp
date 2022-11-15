import 'package:cleanedapp/todo/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userStateChanged =
    ChangeNotifierProvider.autoDispose<BeUserState>((ref) => BeUserState());

class BeUserState extends ChangeNotifier {
  void setNotifyUserChange() {
    notifyListeners();
  }
}

final toDoListStateChanged =
    ChangeNotifierProvider.autoDispose<ToDoListState>((ref) => ToDoListState());

class ToDoListState extends ChangeNotifier {
  TodoList? _todoList;

  void toDoListStateChanged(TodoList list) {
    _todoList = list;
    notifyListeners();
  }

  TodoList? get todoList => _todoList;
}
