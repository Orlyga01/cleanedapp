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
import 'package:sharedor/export_common.dart';
import 'package:sharedor/external_export_view.dart';
import 'package:reorderables/reorderables.dart';
import 'package:sharedor/widgets/first_row_list_add.dart';
import 'package:sharedor/widgets/expanded_inside_list.dart';

import '../user/be_user_model.dart';

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
