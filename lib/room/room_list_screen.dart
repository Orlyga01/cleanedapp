import 'package:authentication/authentication.dart';
import 'package:cleanedapp/export_all_ui.dart';
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
import 'package:sharedor/widgets/floating_action_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  bool? addRoomMode = false;
  bool? updateRoomMode = true;
  bool tileExpanded = false;
  Map<String, GlobalKey<FormState>> gkRoom;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  RoomListWidget({
    Key? key,
    required this.rooms,
    this.addRoomMode,
  })  : gkRoom = {for (var item in rooms) '$item.id': GlobalKey<FormState>()},
        super(key: key);
  @override
  State<RoomListWidget> createState() => RoomListWidgetState();
  // GlobalKey<FormBuilderState>? _formKey =
  //     GlobalKey<FormBuilderState>(debugLabel: "bla");
}

class RoomListWidgetState extends State<RoomListWidget> {
  List<Room> rooms = testRooms;
  BeUser? user = BeUserController().user;
  Room? newRoom;
  @override
  void initState() {
    if (user != null) RoomController().setCurrentRoomList(user!.rooms);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  initialState = false;
    return Consumer(builder: (consumercontext, listen, child) {
      listen(userStateChanged);
      user = BeUserController().user;

      bool initialState = user?.name.isEmptyBe ?? true;
      return SizedBox(
        height: GlobalParametersFM().screenSize.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BeUserEditWidget(),
            ),
            (widget.addRoomMode == true)
                ? Container(
                    height: 400,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: BeStyle.main, width: 2)),
                    child: RoomWidget(
                        formKey: widget._formkey,
                        onChanged: (Room room) {
                          saveRoom(room);
                        }),
                  )
                : const SizedBox.shrink(),
            Flexible(
              child: AbsorbPointer(
                absorbing: initialState,
                child: Opacity(
                  opacity: initialState ? 0.4 : 1,
                  child: buildListRoom(user!.rooms),

                  // child: Consumer(builder: (consumercontext, watch, child) {
                  //   AsyncValue<List<Room>> streammeet = watch(streamUserRooms);
                  //   return streammeet.when(
                  //       data: (value) => buildListRoom(value),
                  //       loading: () => const CircularProgressIndicator(),
                  //       error: (error, stack) => const Text("Error"));
                  // }),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildListRoom(List<Room> rooms) {
    Room emptyRoom = Room.empty;
    return ReorderableListView.builder(
      scrollController: ScrollController(initialScrollOffset: 50),

      onReorder: ((oldIndex, newIndex) {
        print("old: $oldIndex");
        print("new: $newIndex");

        if (oldIndex == 0) {
          oldIndex = newIndex;
        } else {
          Room orig = rooms[oldIndex - 1];
          rooms.removeAt(oldIndex - 1);
          rooms.insert(newIndex - 1, orig);
          rooms[newIndex] = orig;
          updateRoomsList(rooms);
        }
      }),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(8),
      // plus one for the add
      itemCount: rooms.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            key: ValueKey(index == 0 ? '0' : rooms[index - 1].id),
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              border: index == 0
                  ? const Border() // This will create no border for the first item
                  : Border(
                      top: BorderSide(
                          width: 1, color: Theme.of(context).primaryColor)),
            ),
            child: _buildExpandableTile(
                index == 0 ? Room.empty : rooms[index - 1],
                firstAddRow: index == 0));
      },
    );
  }

  Future<void> updateRoomsList(List<Room> rooms) async {
    try {
      await BeUserController().updateRoomListOfUser(rooms);
      setState(() {});
    } catch (e) {
      showAlertDialog(e.toString(), context);
    }
  }

  Widget _buildExpandableTile(Room item, {bool? firstAddRow = false}) {
    return firstAddRow != true
        ? ExpansionTile(
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
                    saveRoom(item);
                  },
                )
              ])
//-------------Add Room Tile------------------
        : NewObjectInList<Room>(
            item: item,
            formkey: widget._formkey,
            onClick: (Room item) => saveRoom(newRoom),
            addRoomMode: true,
            expandedChild: RoomWidget(
              formKey: widget._formkey,
              room: item,
              onChanged: (Room item) {
                setRoom(item);
              },
            ));
  }

  Future<bool> saveRoom(room, {bool? addMode = false}) async {
    setState(() {});
    return true;
    bool? isValid;
    isValid = widget._formkey.currentState?.validate();
    if (!isValid!) return false;
    try {
      await BeUserController().updateRoomOfUser(room);
      setState(() {});
    } catch (e) {
      showAlertDialog(e.toString(), context);
      return false;
    }
    return true;
  }

  setRoom(Room room) {
    newRoom = room;
  }
}

class NewObjectInList<T> extends StatefulWidget {
  // bool expanded = false;
  Future<bool> Function(T) onClick;
  bool addRoomMode;
  Widget expandedChild;
  GlobalKey gk = GlobalKey();

  final GlobalKey<FormState> formkey;

  T item;
  NewObjectInList(
      {Key? key,
      //  required this.expanded,
      required this.onClick,
      required this.formkey,
      required this.expandedChild,
      this.addRoomMode = false,
      required this.item})
      : super(key: key);

  @override
  State<NewObjectInList> createState() => _NewObjectInListState<T>();
}

class _NewObjectInListState<T> extends State<NewObjectInList<T>> {
  bool initiallyExpanded = false;
  bool tileExpanded = false;
  @override
  Widget build(BuildContext context) {
    print("tileexp" + tileExpanded.toString());
    return ExpansionTile(
      key: Key('0111'),
      initiallyExpanded: tileExpanded,
      onExpansionChanged: (expended) {
        tileExpanded = expended;
        setState(() {});
      },
      title: Text("Add room".ctr(), style: BeStyle.inputHint),
      leading: const Icon(LineAwesomeIcons.plus_circle, color: BeStyle.main),
      trailing: tileExpanded
          ? ElevatedButton(
              child: Text("Save".ctr()),
              onPressed: () async {
                bool success = await widget.onClick(widget.item);
                print("success" + success.toString());
                //   if (success) setState(() {});
              })
          //   onPressed: () {})
          : const SizedBox.shrink(),
      children: <Widget>[widget.expandedChild],
    );
  }
}
