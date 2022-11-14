import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cleanedapp/export_all_ui.dart';
import 'package:cleanedapp/helpers/global_parameters.dart';
import 'package:cleanedapp/master_page.dart';
import 'package:cleanedapp/misc/providers.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:cleanedapp/room/room_widget.dart';
import 'package:cleanedapp/user/be_user_controller.dart';
import 'package:cleanedapp/user/be_user_edit_widget.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:sharedor/export_common.dart';
import 'package:sharedor/external_export_view.dart';
import 'package:sharedor/helpers/export_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reorderables/reorderables.dart';
import 'package:sharedor/widgets/first_row_list_add.dart';
import 'package:sharedor/widgets/expanded_inside_list.dart';
import 'package:sharedor/widgets/radio_buttons.dart';

import '../user/be_user_model.dart';

class RoomListScreen extends StatelessWidget {
  final GlobalKey<RoomListWidgetState> _key = GlobalKey<RoomListWidgetState>();
  BeUser user = BeUserController().user;

  // ignore: use_key_in_widget_constructors
  RoomListScreen({Key? key});
  @override
  Widget build(BuildContext context) {
    return AppMainTemplate(
        isHome: true,
        inPageTitle: "Manage house cleaning task".ctr(),
        title: const Text("Clean App"),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        children: [
          RoomListWidget(
            key: _key,
            rooms: testRooms,
          )
        ]);
  }
}

class RoomListWidget extends StatefulWidget {
  final List<Room> rooms;
  bool? updateRoomMode = true;
  bool tileExpanded = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  RoomListWidget({
    Key? key,
    required this.rooms,
  }) : super(key: key);
  @override
  State<RoomListWidget> createState() => RoomListWidgetState();
  // GlobalKey<FormBuilderState>? _formKey =
  //     GlobalKey<FormBuilderState>(debugLabel: "bla");
}

class RoomListWidgetState extends State<RoomListWidget> {
  BeUser user = BeUserController().user;
  late Map<String, GlobalKey<FormState>> gkRoom = {};
  List<Room> rooms = [];
  bool editState = false;

  //     if (user != null) RoomController().setCurrentRoomList(user!.rooms);

  @override
  void initState() {
    user = BeUserController().user;
    rooms = user.rooms;

    for (var item in user.rooms) {
      gkRoom[item.id] = GlobalKey<FormState>();
    }

    super.initState();
  }

  Future<void> updateRoomsList(List<Room> rooms) async {
    try {
      await BeUserController().updateRoomListOfUser(rooms);
      setState(() {});
    } catch (e) {
      showAlertDialog(e.toString(), context);
    }
  }

  Future<bool> deleteRoom(Room room, BuildContext context) async {
    try {
      await BeUserController().deleteUserRoom(room);
      // ignore: use_build_context_synchronously
      context.read(userStateChanged.notifier).setNotifyUserChange();
    } catch (e) {
      log(e.toString());
      // showAlertDialog(e.toString(), context);
      return false;
    }

    return true;
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
      updateRoomsList(rooms);
    }
    setState(() {
      // Widget row = _rows.removeAt(oldIndex);
      // _rows.insert(newIndex, row);
    });
  }

  HouseType houseType = HouseType.flat;

  @override
  Widget build(BuildContext context) {
    // Make sure there is a scroll controller attached to the scroll view that contains ReorderableSliverList.
    // Otherwise an error will be thrown.
    return Consumer(builder: (consumercontext, WidgetRef ref, child) {
      ref.watch(userStateChanged);
      bool initialState = user.name.isEmptyBe;
      print('in$initialState');
      return SizedBox(
        height: GlobalParametersFM().screenSize.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BeUserEditWidget(),
            ),
            Flexible(
              child: AbsorbPointer(
                absorbing: initialState,
                child: Opacity(
                  opacity: initialState ? 0.4 : 1,
                  child: Column(
                    children: [
                      listTemplateSelection(),
                      buildListRoom(user.rooms),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget listTemplateSelection() {
    if (user.id.isEmptyBe || user.lists.isEmptyBe) return SizedBox.shrink();
    return RadioButtonWidget(
        selectedItem: HouseType.flat,
        items: HouseType.values,
        onChange: (value) {
          setSate() {
            houseType = value;
          }
        });
  }

  Widget buildListRoom(List<Room> rooms) {
    List<Widget> _rows = [];
    _rows = List<Widget>.generate(
      rooms.length,
      (int index) {
        Room item = rooms[index];
        return Container(
          color: Colors.greenAccent,
          key: ValueKey(item.id),
          child:
              //Text("id:" + (rooms[index].id)
              ExapndableInList<Room>(
                  item: item,
                  extraActions: [
                    IconButton(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        constraints: const BoxConstraints(),
                        onPressed: () async {
                          Navigator.pushNamed(context, "backofficeroom",
                              arguments: {"roomid": item.id});
                        },
                        icon: const Icon(LineAwesomeIcons.tasks)),
                  ],
                  leading:
                      Icon(RoomTypes[item.type]!.icon ?? Icons.abc_outlined),
                  title: Container(color: Colors.blue, child: Text(item.title)),
                  formkey: widget._formkey,
                  onClickDelete: (Room item) => deleteRoom(item, context),
                  expandedChild: RoomWidget(
                    formKey: GlobalKey<FormState>(),
                    room: rooms[index],
                    onChanged: (Room item) {
                      rooms[index] = item;
                    },
                  )),
        );
      },
    );
    Room emptyroom = Room.empty;
    _rows = <Widget>[
          Container(
            key: const ValueKey('0'),
            child: NewObjectInList<Room>(
                item: emptyroom,
                addTitle: "Add room",
                formkey: widget._formkey,
                //  onClick: (Room item) => ,
                addRoomMode: true,
                expandedChild: RoomWidget(
                  formKey: widget._formkey,
                  room: emptyroom,
                  onChanged: (Room item) {
                    emptyroom = item;
                  },
                )),
          )
        ] +
        _rows;
    return ReorderableColumn(
      children: _rows,
      onReorder: _onReorder,
    );
  }
}
