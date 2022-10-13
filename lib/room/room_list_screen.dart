import 'package:cleanedapp/master_page.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sharedor/widgets/floating_action_button.dart';

class RoomListScreen extends StatelessWidget {
  RoomListScreen({Key? key});
  @override
  Widget build(BuildContext context) {
    return AppMainTemplate(
        isHome: true,
        title: Text("Clean App"),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: AddActionButton(
          //  child: Text("hi"),
          onPressed: () {},
        ),
        children: [RoomListWidget(rooms: testRooms)]);
  }
}

class RoomListWidget extends StatefulWidget {
  final List rooms;
  RoomListWidget({Key? key, required this.rooms}) : super(key: key);

  @override
  State<RoomListWidget> createState() => _RoomListWidgetState();
}

class _RoomListWidgetState extends State<RoomListWidget> {
  List<Room> rooms = testRooms;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
    );
  }

  Widget _buildExpandableTile(Room item) {
    return ExpansionTile(
      maintainState: true,
      leading: Icon(RoomTypes[item.type]!.icon ?? Icons.abc_outlined),
      title: Text(
        item.roomNo + ' ' + (item.title ?? ''),
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
}
