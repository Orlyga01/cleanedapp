import 'dart:async';
import 'package:cleanedapp/misc/providers.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:cleanedapp/task/task_model.dart';
import 'package:cleanedapp/todo/todo_model.dart';
import 'package:cleanedapp/todo/todo_repository.dart';
import 'package:cleanedapp/user/be_user_controller.dart';
import 'package:cleanedapp/user/be_user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoController {
  static final TodoController _todoListC = TodoController._internal();
  late TodoListRepository _todoRepository;

  TodoController._internal();
  TodoList? _todoList;
  factory TodoController() {
    _todoListC._todoRepository = TodoListRepository(todoListid: '');
    return _todoListC;
  }
  void init() async {
    TodoList? todoList = await getUserLatestList();
    _todoList = todoList ?? TodoList.empty;

    // setTodoList(_todoList);
  }

  Future<TodoList?> getUserLatestList() async {
    String? id = BeUserController().latestListId;
    try {
      TodoList? list = await _todoRepository.get(id);
      _todoList = list;
    } catch (e) {}
  }

  setTodoList(TodoList user) {
    // _todoRepository.setListId = _todoList.id;
    // _beUser.rooms.removeRange(5, _beUser.rooms.length);

    // updateBeUser(user.id,
    //     fieldName: "rooms", fieldValue: user.listToJson(_beUser.rooms));
    //  RoomController().setCurrentRoomList(_beUser.rooms);

    // setOfflineUser(user);
  }
  final StreamController<TodoList> listItems = StreamController<TodoList>();

  Stream<TodoList> get getTodo => listItems.stream;
  //UserController repository = locator.get<UserController>();
  TodoList _list = TodoList.empty;

  Future<void> setCurrentTodo(TodoList list) async {
    _list = list;

    listItems.sink.add(_list);
  }

  void dispose() {
    listItems.close();
  }

  Future<void> updateTodo() async {
    //Do update menu then sink
    // we want that new or recently updated would always be the first in the list
    listItems.sink.add(_list);
  }

  List<Task> getTaskByRoom(String room) {
    return [];
  }

  Future<TodoList?> add(
    TodoList todoList,
  ) async {
    TodoList? returnTodoList;
    try {
      returnTodoList = await _todoRepository.add(todoList);
      _todoList = returnTodoList ?? todoList;
      if (returnTodoList != null) {
        BeUserController().addListId(returnTodoList.id);
        //TODO keep the current list locally
        // setOfflineUser(returnTodoList);
      }
      return (returnTodoList != null) ? returnTodoList : null;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> updateTodoList(String id,
      {TodoList? user, String? fieldName, dynamic fieldValue}) async {
    if (fieldName != null) {
      _todoList!.toJson()[fieldName] = fieldValue;
    } else {
      _todoList = user!;
    }
    try {
      await _todoRepository.update(id, user, fieldName, fieldValue);
      // setOfflineUser(_todoList);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<TodoList> createList(
      {String origin = "auto", WidgetRef? notifiyer}) async {
    BeUser user = BeUserController().user;
    TodoList ret = TodoList.empty;
    print("ddddd${ret.id}");
    switch (origin) {
      case "prev":
      case "auto":
        if (user.listsid == null || user.listsid!.length == 0) {
          ret = TodoList(
              tasks: convertToInstance(testRooms),
              userid: user.id,
              cleanerid: '',
              title: "Tasks For");
        } else {
          TodoList? prev = await _todoRepository.get(user.listsid![0]);
          if (prev == null) {
            print(user.listsid![0] + " list id doesnt exist");
            throw "${user.listsid![0]} list id doesnt exist";
          }
          ret = TodoList(
              tasks: clone(prev.tasks),
              userid: user.id,
              cleanerid: prev.cleanerid,
              title: "title");
        }
        break;
      default:
    }
    //automatically save the new list
    _todoRepository.add(ret).then((TodoList? value) {
      if (notifiyer != null && value != null) {
        notifiyer
            .read(toDoListStateChanged.notifier)
            .toDoListStateChanged(value);
      }
    }).catchError((Object error) => print("error ${error.toString()}"));
    print(ret.tasks.length);
    return ret;
  }

  List<ToDoRoom> clone(List<ToDoRoom> rooms) {
    List<ToDoRoom> todoList = [];
    for (ToDoRoom room in rooms) {
      todoList.add(
        ToDoRoom.empty
          ..roomId = room.id
          ..active = room.active,
      );
      for (ToDoTask task in room.tasks) {
        todoList[todoList.length - 1].tasks.add(ToDoTask.empty
          ..taskId = task.id
          ..active = task.active);
      }
    }
    return todoList;
  }

  List<ToDoRoom> convertToInstance(List<Room> rooms) {
    List<ToDoRoom> todoList = [];
    for (Room room in rooms) {
      todoList.add(
        ToDoRoom.empty..roomId = room.id,
      );
      for (Task task in room.roomTasks) {
        todoList[todoList.length - 1]
            .tasks
            .add(ToDoTask.empty..taskId = task.id);
      }
    }
    return todoList;
  }

  TodoList? get todoList => _todoList;
}

final streamTask = StreamProvider.autoDispose<TodoList>((ref) {
  ref.onDispose(() => print("controller for uid was disposed"));
  return TodoController().getTodo;
});
