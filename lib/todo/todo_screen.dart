import 'dart:developer';

import 'package:cleanedapp/export_all_ui.dart';
import 'package:cleanedapp/helpers/global_parameters.dart';
import 'package:cleanedapp/master_page.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:cleanedapp/task/task_model.dart';
import 'package:cleanedapp/todo/todo_controller.dart';
import 'package:cleanedapp/todo/todo_model.dart';
import 'package:cleanedapp/todo/todo_widget.dart';
import 'package:cleanedapp/user/be_user_controller.dart';
import 'package:cleanedapp/user/be_user_model.dart';
import 'package:flutter/material.dart';
import 'package:sharedor/export_common.dart';
import 'package:reorderables/reorderables.dart';
import 'package:sharedor/helpers/export_helpers.dart';
import 'package:sharedor/widgets/expanded_inside_list.dart';
import 'package:sharedor/widgets/logo_spin.dart';
import 'package:translator/translator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToDoScreen extends StatelessWidget {
  late bool newList;
  final GlobalKey<ToDoWidgetState> _key = GlobalKey<ToDoWidgetState>();

  // ignore: use_key_in_widget_constructors
  ToDoScreen({Key? key, this.newList = false});
  TodoList? todoList;

  Future<TodoList?> createList() async {
    newList = todoList == null ? true : newList;

    if (newList) {
      return await TodoController().createList();
    }
    return null;
  }

  String get getTitle {
    return newList
        ? "New generated list".ctr()
        : '${"Latest list from".ctr()} ${toDate(todoList!.modifiedAt)}';
  }

  @override
  Widget build(BuildContext context) {
    TodoController().getUserLatestList();

    return FutureBuilder(
        future: createList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LogoSpinner();
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            todoList = snapshot.data as TodoList;

            return AppMainTemplate(
                isHome: false,
                inPageTitle: getTitle,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.startTop,
                children: [
                  todoList != null
                      ? ToDoWidget(
                          key: _key,
                          rooms: todoList!.tasks,
                        )
                      : LogoSpinner()
                ]);
          }
        });
  }
}

class ToDoWidget extends StatefulWidget {
  final List<ToDoRoom> rooms;
  bool? updateRoomMode = true;
  bool tileExpanded = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  ToDoWidget({
    Key? key,
    required this.rooms,
  }) : super(key: key);
  @override
  State<ToDoWidget> createState() => ToDoWidgetState();
  // GlobalKey<FormBuilderState>? _formKey =
  //     GlobalKey<FormBuilderState>(debugLabel: "bla");
}

class ToDoWidgetState extends State<ToDoWidget> {
  BeUser user = BeUserController().user;
  late Map<String, GlobalKey<FormState>> gkRoom = {};
  List<Room> rooms = [];
  bool editState = false;

  //     if (user != null) RoomController().setCurrentToDo(user!.rooms);
  ScrollController scont = ScrollController();
  @override
  void initState() {
    user = BeUserController().user;
    rooms = user.rooms;

    for (var item in user.rooms) {
      gkRoom[item.id] = GlobalKey<FormState>();
    }

    super.initState();
  }

  setScroll(ScrollController scrollController) {
    if (scont.hasClients) {
      scont.animateTo(scont.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    //abort if first row has been dragged or if try to drag above the first row
    if (oldIndex == 0 || newIndex == 0) {
      oldIndex = newIndex;
    } else {
      Room orig = rooms[oldIndex - 1];
      rooms.removeAt(oldIndex - 1);
      rooms.insert(newIndex - 1, orig);
      // rooms[newIndex] = orig;
      // updateRoomsList(rooms);
    }
    setState(() {
      // Widget row = _rows.removeAt(oldIndex);
      // _rows.insert(newIndex, row);
    });
  }

  bool reset = true;

  @override
  Widget build(BuildContext context) {
    // Make sure there is a scroll controller attached to the scroll view that contains ReorderableSliverList.
    // Otherwise an error will be thrown.
    user = BeUserController().user;
    bool initialState = user.name.isEmptyBe;
    return SizedBox(
      height: GlobalParametersFM().screenSize.height,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: InkWell(
              child: const Text("translate"),
              onTap: () => translate(),
            ),
          ),
          Expanded(child: buildListRoom(user.rooms)),
        ],
      ),
    );
  }

  translate() async {
    reset = !reset;
    if (reset) {
      rooms = rooms = user.rooms;
      setState(() {});
      return;
    }

    final translator = GoogleTranslator();
    List<String> listTotranslate = [];

    for (Room room in rooms) {
      listTotranslate += [room.title, room.description ?? '-'];
      for (Task task in room.roomTasks) {
        listTotranslate += [task.title, task.description ?? '-'];
      }
    }

    var t = await translator.translate(listTotranslate.join(')('),
        from: 'en', to: 'iw');
    listTotranslate = t.toString().split(') (');

    int transListCounter = 0;
    for (var i = 0; i < rooms.length; i++) {
      rooms[i].title = listTotranslate[transListCounter];
      rooms[i].description = listTotranslate[transListCounter + 1].trim() == '-'
          ? null
          : listTotranslate[transListCounter + 1];
      transListCounter = transListCounter + 2;
      for (var j = 0; j < rooms[i].roomTasks.length; j++) {
        rooms[i].roomTasks[j].title = listTotranslate[transListCounter];
        rooms[i].roomTasks[j].description =
            listTotranslate[transListCounter + 1].trim() == '-'
                ? null
                : listTotranslate[transListCounter + 1];
        transListCounter = transListCounter + 2;
      }

      // transRooms.add(room
      //   ..title = ''
      //   ..description = '');

    }
    setState(() {});
  }

  Widget buildListRoom(List<Room> rooms) {
    List<Widget> _rows = [];
    _rows = List<Widget>.generate(
      rooms.length,
      (int index) {
        Room item = rooms[index];
        return Container(
          key: ValueKey(item.id),
          child:
              //Text("id:" + (rooms[index].id))
              ExapndableInList<Room>(
                  item: item,
                  slideExpandCollapse: true,
                  showEdit: false,
                  initialExpanded: true,
                  title: Text(item.title),
                  formkey: widget._formkey,
                  expandedChild: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TaskListWidget(
                      listInRoomMode: true,
                      room: rooms[index],
                    ),
                  )),
        );
      },
    );
    Room emptyroom = Room.empty;
    return ReorderableColumn(
      children: _rows,
      onReorder: _onReorder,
    );
  }
}
