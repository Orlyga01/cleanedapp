import 'package:cleanedapp/user/be_user_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:cleanedapp/master_page.dart';

class UserScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  UserScreen({Key? key});
  @override
  Widget build(BuildContext context) {
    return AppMainTemplate(
        isHome: true,
        title: const Text("User"),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        children: [BeUserEditWidget()]);
  }
}

class SendToCleanerScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  final String? listId;
  SendToCleanerScreen({Key? key, required this.listId});
  @override
  Widget build(BuildContext context) {
    return AppMainTemplate(
        isHome: true,
        title: const Text("User"),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        children: [BeUserEditWidget()]);
  }
}
