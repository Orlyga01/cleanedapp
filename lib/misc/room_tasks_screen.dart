import 'package:cleanedapp/master_page.dart';
import 'package:cleanedapp/room/room_controller.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:cleanedapp/room/room_widget.dart';
import 'package:cleanedapp/todo/todo_widget.dart';

import 'package:flutter/material.dart';
import 'package:sharedor/helpers/export_helpers.dart';

class BackOfficeRoomScreen extends StatelessWidget {
  final GlobalKey<TaskListWidgetState> _key = GlobalKey<TaskListWidgetState>();
  final String roomId;
  // ignore: use_key_in_widget_constructors
  BackOfficeRoomScreen({Key? key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    Room room = RoomController().getRoomById(roomId);

    return AppMainTemplate(
        isHome: true,
        showBack: true,
        title: Text("${"Tasks".ctr()} for ${room.title}"),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        children: [
          RoomWidget(
            formKey: GlobalKey<FormState>(),
            showRoomTitle: true,
            room: room,
            readOnly: true,
          ),
          const Divider(),
          TaskListWidget(
            key: _key,
            room: room,
          )
        ]);
  }
}
