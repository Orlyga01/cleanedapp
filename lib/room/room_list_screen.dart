import 'package:cleanedapp/helpers/global_parameters.dart';
import 'package:cleanedapp/master_page.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:cleanedapp/room/room_widget.dart';
import 'package:cleanedapp/user/be_user_controller.dart';
import 'package:cleanedapp/user/be_user_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sharedor/export_common.dart';
import 'package:sharedor/helpers/export_helpers.dart';
import 'package:sharedor/widgets/floating_action_button.dart';

import '../user/be_user_model.dart';

class RoomListScreen extends StatelessWidget {
  final GlobalKey<RoomListWidgetState> _key = GlobalKey<RoomListWidgetState>();

  RoomListScreen({Key? key});
  @override
  Widget build(BuildContext context) {
    return AppMainTemplate(
        isHome: true,
        title: Text("Clean App"),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // widget._formKey = null;
  }

  @override
  Widget build(BuildContext context) {
    bool initialState = user?.name.isEmptyBe ?? true;
    initialState = false;
    return Container(
      height: GlobalParametersFM().screenSize.height,
      child: Column(
        children: [
          BeUserEditWidget(),
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
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  // plus one for the add
                  itemCount: rooms.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          border: index == 0
                              ? const Border() // This will create no border for the first item
                              : Border(
                                  top: BorderSide(
                                      width: 1,
                                      color: Theme.of(context).primaryColor)),
                        ),
                        child: _buildExpandableTile(
                            index == 0 ? Room.empty : rooms[index - 1],
                            firstAddRow: index == 0));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableTile(Room item, {bool? firstAddRow = false}) {
    return firstAddRow != true
        ? ExpansionTile(
            maintainState: true,
            leading: Icon(RoomTypes[item.type]!.icon ?? Icons.abc_outlined),
            title: Text(
              (item.title),
            ),
            children: <Widget>[
              RoomWidget(
                  room: item,
                  readOnly: true,
                  formKey: widget.gkRoom[item.id] ?? GlobalKey<FormState>(),
                  onChanged: (Room room) {
                    saveRoom(room);
                  }),
            ],
          )
        : ExpansionTile(
            maintainState: true,
            trailing: SizedBox.shrink(),
            leading: Icon(LineAwesomeIcons.plus_circle, color: BeStyle.main),
            title: Text("Add room".ctr(), style: BeStyle.inputHint),
            children: <Widget>[
              RoomWidget(
                  formKey: widget._formkey,
                  onChanged: (Room room) {
                    saveRoom(room);
                  }),
            ],
          );
  }

  saveRoom(Room room) {
    bool? isValid;
    isValid = widget._formkey.currentState?.validate();
    if (isValid != false) {
      print("----needToSaveRoom");
      // If add mode and add was success, then any next change is update
    } else {}
  }
}
