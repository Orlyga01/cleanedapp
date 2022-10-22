import 'package:cleanedapp/helpers/global_parameters.dart';
import 'package:cleanedapp/master_page.dart';
import 'package:cleanedapp/misc/providers.dart';
import 'package:cleanedapp/room/room_controller.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:cleanedapp/room/room_widget.dart';
import 'package:cleanedapp/user/be_user_controller.dart';
import 'package:cleanedapp/user/be_user_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sharedor/export_common.dart';
import 'package:sharedor/external_export_view.dart';
import 'package:sharedor/helpers/export_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reorderables/reorderables.dart';
import 'package:sharedor/widgets/first_row_list_add.dart';

import '../user/be_user_model.dart';

class RoomListScreen extends StatelessWidget {
  final GlobalKey<RoomListWidgetState> _key = GlobalKey<RoomListWidgetState>();

  // ignore: use_key_in_widget_constructors
  RoomListScreen({Key? key});
  @override
  Widget build(BuildContext context) {
    return AppMainTemplate(
        isHome: true,
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
  Map<String, GlobalKey<FormState>> gkRoom;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
//   BeUser? user = BeUserController().user;
//   Room? newRoom;
//   @override
//   void initState() {
//     if (user != null) RoomController().setCurrentRoomList(user!.rooms);
//     super.initState();
//   }
  RoomListWidget({
    Key? key,
    required this.rooms,
  })  : gkRoom = {for (var item in rooms) '$item.id': GlobalKey<FormState>()},
        super(key: key);
  @override
  State<RoomListWidget> createState() => RoomListWidgetState();
  // GlobalKey<FormBuilderState>? _formKey =
  //     GlobalKey<FormBuilderState>(debugLabel: "bla");
}

class RoomListWidgetState extends State<RoomListWidget> {
  BeUser user = BeUserController().user;
  List<Room> rooms = [];

  //     if (user != null) RoomController().setCurrentRoomList(user!.rooms);

  @override
  void initState() {
    user = BeUserController().user;
    rooms = user.rooms;

    super.initState();
  }

  Widget _buildExpandableTile(Room item) {
    return ExpansionTile(
        leading: Icon(RoomTypes[item.type]!.icon ?? Icons.abc_outlined),
        title: Text(
          (item.title),
        ),
        children: <Widget>[
          RoomWidget(
            room: item,
            readOnly: true,
            formKey: widget.gkRoom[item.id] ?? GlobalKey<FormState>(),
            onChanged: (Room item) {
              // saveRoom(item);
            },
          )
        ]);
  }

  Future<void> updateRoomsList(List<Room> rooms) async {
    try {
      await BeUserController().updateRoomListOfUser(rooms);
      setState(() {});
    } catch (e) {
      showAlertDialog(e.toString(), context);
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
      updateRoomsList(rooms);
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

    return Consumer(builder: (consumercontext, listen, child) {
      listen(userStateChanged);
      user = BeUserController().user;
      bool initialState = user.name.isEmptyBe;
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
                  child: buildListRoom(user.rooms),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildListRoom(List<Room> rooms) {
    List<Widget> _rows = [];

    _rows = List<Widget>.generate(
        rooms.length,
        (int index) => Container(
            key: ValueKey(rooms[index].id),
            child: _buildExpandableTile(rooms[index])));
    Room emptyroom = Room.empty;
    _rows = <Widget>[
          Container(
            key: ValueKey('0'),
            child: NewObjectInList<Room>(
                item: emptyroom,
                formkey: widget._formkey,
                onClick: (Room item) => saveRoom(emptyroom),
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

  Future<bool> saveRoom(Room room, {bool? addMode = false}) async {
    print(room.type);
    bool? isValid;
    isValid = widget._formkey.currentState?.validate();
    if (isValid == false) return false;
    try {
      await BeUserController().updateRoomOfUser(room);
      setState(() {});
    } catch (e) {
      showAlertDialog(e.toString(), context);
      return false;
    }
    return true;

    // if (!isValid!) return false;
    // try {
    //   await BeUserController().updateRoomOfUser(room);
    //   setState(() {});
    // } catch (e) {
    //   showAlertDialog(e.toString(), context);
    //   return false;
    // }
    // return true;
  }
}
//   @override
//   Widget build(BuildContext context) {
//     //  initialState = false;
//     return Consumer(builder: (consumercontext, listen, child) {
//       listen(userStateChanged);
//       user = BeUserController().user;

//       bool initialState = user?.name.isEmptyBe ?? true;
//       return SizedBox(
//         height: GlobalParametersFM().screenSize.height,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: BeUserEditWidget(),
//             ),
//             (widget.addRoomMode == true)
//                 ? Container(
//                     height: 400,
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: BeStyle.main, width: 2)),
//                     child: RoomWidget(
//                         formKey: widget._formkey,
//                         onChanged: (Room room) {
//                           saveRoom(room);
//                         }),
//                   )
//                 : const SizedBox.shrink(),
//             Flexible(
//               child: AbsorbPointer(
//                 absorbing: initialState,
//                 child: Opacity(
//                   opacity: initialState ? 0.4 : 1,
//                   child: buildListRoom(user!.rooms),

//                   // child: Consumer(builder: (consumercontext, watch, child) {
//                   //   AsyncValue<List<Room>> streammeet = watch(streamUserRooms);
//                   //   return streammeet.when(
//                   //       data: (value) => buildListRoom(value),
//                   //       loading: () => const CircularProgressIndicator(),
//                   //       error: (error, stack) => const Text("Error"));
//                   // }),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   Widget buildListRoom(List<Room> rooms) {
//     Room emptyRoom = Room.empty;
//     return ReorderableListView.builder(
//       scrollController: ScrollController(initialScrollOffset: 50),

//       onReorder: ((oldIndex, newIndex) {
//         print("old: $oldIndex");
//         print("new: $newIndex");

//         if (oldIndex == 0) {
//           oldIndex = newIndex;
//         } else {
//           Room orig = rooms[oldIndex - 1];
//           rooms.removeAt(oldIndex - 1);
//           rooms.insert(newIndex - 1, orig);
//           rooms[newIndex] = orig;
//           updateRoomsList(rooms);
//         }
//       }),
//       scrollDirection: Axis.vertical,
//       shrinkWrap: true,
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.all(8),
//       // plus one for the add
//       itemCount: rooms.length + 1,
//       itemBuilder: (BuildContext context, int index) {
//         return Container(
//             key: ValueKey(index == 0 ? '0' : rooms[index - 1].id),
//             padding: const EdgeInsets.all(0),
//             decoration: BoxDecoration(
//               border: index == 0
//                   ? const Border() // This will create no border for the first item
//                   : Border(
//                       top: BorderSide(
//                           width: 1, color: Theme.of(context).primaryColor)),
//             ),
//             child: _buildExpandableTile(
//                 index == 0 ? Room.empty : rooms[index - 1],
//                 firstAddRow: index == 0));
//       },
//     );
//   }

  

//   Widget _buildExpandableTile(Room item, {bool? firstAddRow = false}) {
//     return firstAddRow != true
//         ? ExpansionTile(
//             leading: Icon(RoomTypes[item.type]!.icon ?? Icons.abc_outlined),
//             title: Text(
//               (item.title),
//             ),
//             children: <Widget>[
//                 RoomWidget(
//                   room: item,
//                   readOnly: true,
//                   formKey: widget.gkRoom[item.id] ?? GlobalKey<FormState>(),
//                   onChanged: (Room item) {
//                     saveRoom(item);
//                   },
//                 )
//               ])
// //-------------Add Room Tile------------------
//         : NewObjectInList<Room>(
//             item: item,
//             formkey: widget._formkey,
//             onClick: (Room item) => saveRoom(newRoom),
//             addRoomMode: true,
//             expandedChild: RoomWidget(
//               formKey: widget._formkey,
//               room: item,
//               onChanged: (Room item) {
//                 setRoom(item);
//               },
//             ));
//   }

 
