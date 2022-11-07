import 'dart:developer';

import 'package:cleanedapp/export_all_ui.dart';
import 'package:cleanedapp/helpers/global_parameters.dart';
import 'package:cleanedapp/master_page.dart';
import 'package:cleanedapp/misc/providers.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:cleanedapp/room/room_widget.dart';
import 'package:cleanedapp/todo/todo_widget.dart';
import 'package:cleanedapp/user/be_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:sharedor/export_common.dart';
import 'package:reorderables/reorderables.dart';
import 'package:sharedor/widgets/expanded_inside_list.dart';

import '../user/be_user_model.dart';

class ToDoScreen extends StatelessWidget {
  final GlobalKey<ToDoWidgetState> _key = GlobalKey<ToDoWidgetState>();

  // ignore: use_key_in_widget_constructors
  ToDoScreen({Key? key});
  @override
  Widget build(BuildContext context) {
    return AppMainTemplate(
        isHome: true,
        title: const Text("Clean App"),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        children: [
          ToDoWidget(
            key: _key,
            rooms: testRooms,
          )
        ]);
  }
}

class ToDoWidget extends StatefulWidget {
  final List<Room> rooms;
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
    if (scont.hasClients)
      scont.animateTo(scont.position.maxScrollExtent,
          duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
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
          Expanded(child: buildListRoom(user.rooms)),
        ],
      ),
    );
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
