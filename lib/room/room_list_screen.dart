import 'package:cleanedapp/master_page.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:cleanedapp/room/room_widget.dart';
import 'package:flutter/material.dart';
import 'package:sharedor/export_common.dart';
import 'package:sharedor/widgets/floating_action_button.dart';

class RoomListScreen extends StatelessWidget {
  final GlobalKey<RoomListWidgetState> _key = GlobalKey<RoomListWidgetState>();

  RoomListScreen({Key? key});
  @override
  Widget build(BuildContext context) {
    return AppMainTemplate(
        isHome: true,
        title: Text("Clean App"),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: AddActionButton(
          //  child: Text("hi"),
          onPressed: () {
            _key.currentState!.udateState(addRoomMode: true);
          },
        ),
        children: [
          RoomListWidget(
            key: _key,
            rooms: testRooms,
          )
        ]);
  }
}

class RoomListWidget extends StatefulWidget {
  final List rooms;
  bool? addRoomMode = false;
  bool? updateRoomMode = true;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  RoomListWidget({
    Key? key,
    required this.rooms,
    this.addRoomMode,
  }) : super(key: key);

  @override
  State<RoomListWidget> createState() => RoomListWidgetState();
  // GlobalKey<FormBuilderState>? _formKey =
  //     GlobalKey<FormBuilderState>(debugLabel: "bla");
}

class RoomListWidgetState extends State<RoomListWidget> {
  List<Room> rooms = testRooms;

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
    return Column(
      children: [
        (widget.addRoomMode != true)
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
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: rooms.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  border: index == 0
                      ? const Border() // This will create no border for the first item
                      : Border(
                          top: BorderSide(
                              width: 1, color: Theme.of(context).primaryColor)),
                ),
                child: _buildExpandableTile(rooms[index]));
          },
        ),
      ],
    );
  }

  udateState({addRoomMode}) {
    setState(() {
      widget.addRoomMode = addRoomMode;
    });
  }

  Widget _buildExpandableTile(Room item) {
    return ExpansionTile(
      maintainState: true,
      leading: Icon(RoomTypes[item.type]!.icon ?? Icons.abc_outlined),
      title: Text(
        (item.title),
      ),
      children: <Widget>[
        ListTile(
          title: Text(
            item.description ?? "",
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        )
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
