//import 'package:bemember/generic_test.dart';

import 'package:cleanedapp/user/be_user_controller.dart';
import 'package:cleanedapp/user/be_user_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cleanedapp/helpers/global_parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sharedor/export_common.dart';
import 'package:sharedor/helpers/device.dart';
import 'package:sharedor/helpers/export_helpers.dart';
import 'dart:ui' as ui;
import 'package:sharedor/widgets/alerts.dart';

class AppMainTemplate extends StatelessWidget {
  final List<Widget> children;
  final Widget? title;
  final bool? isHome;
  final bool? showBack;
  final bool? areYouSure;
  final List<Widget>? persistentFooterButtons;
  final Widget? bottomArea;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final Widget? topLeftArea;
  const AppMainTemplate(
      {Key? key,
      required this.children,
      this.title,
      this.actions,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.persistentFooterButtons,
      this.isHome,
      this.showBack,
      this.areYouSure,
      this.topLeftArea,
      this.bottomArea})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget nav = showBack == true
        ? IconButton(
            icon: Icon(
                Directionality.of(context) == ui.TextDirection.ltr
                    ? Icons.keyboard_arrow_left
                    : Icons.keyboard_arrow_right,
                color: BeStyle.textColor),
            onPressed: () => areYouSure == true
                ? showDialogBe(context, "showOKCancelDialog",
                    onPressOK: () => Navigator.of(context).pop())
                : Navigator.of(context).pop(),
          )
        : (isHome != true)
            ? IconButton(
                color: BeStyle.textColorLight,
                onPressed: () => Navigator.pushNamed(
                      context,
                      "clientlist",
                    ),
                icon: const Icon(LineAwesomeIcons.home))
            : const SizedBox.shrink();

    // ignore: unused_local_variable
    List<Widget>? actionList;
    if (actions != null) actionList = actions!;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Image.asset(
        //   'assets/backgrounds/bg1.jpg',
        //   repeat: ImageRepeat.repeat,
        //   height: GlobalParametersFM().screenSize.height,
        //   width: GlobalParametersFM().screenSize.width,
        // ),
        Scaffold(
            key: GlobalKey<ScaffoldState>(),
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            // drawer: MenuDrawer(listTiles: [], outsideContext: context),
            // key: _scaffoldKey,
            appBar: AppBar(
                backgroundColor: Colors.blueGrey.shade50,
                toolbarHeight: 30,
                toolbarTextStyle: const TextStyle(color: BeStyle.textColor),
                toolbarOpacity: 0.8,
                title: Row(
                  children: [
                    title ?? const SizedBox.expand(),
                  ],
                ),
                centerTitle: true,
                leading: nav,
                actions: actions),
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            persistentFooterButtons: [
              InkWell(
                  onTap: () {
                    BeUserController().clearUser();
                  },
                  child: const Text("Clear User")),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "userscreen");
                  },
                  child: const Text("User")),
            ],
            //persistentFooterButtons: persistentFooterButtons,
            body: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                FocusScope.of(context).requestFocus(FocusNode());

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SafeArea(
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        SizedBox(
                          //   color: Colors.red,
                          height: GlobalParametersFM().screenSize.height * 0.75,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: children.length,
                              itemBuilder: (context, index) {
                                return children[index];
                              }),
                        ),
                        if (bottomArea != null)
                          Positioned.directional(
                              textDirection: Directionality.of(context),
                              end: 0,
                              bottom: 0,
                              child: Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                            top: BorderSide(width: 2),
                                          )),
                                      child: bottomArea!))),
                        if (topLeftArea != null)
                          Positioned.directional(
                              textDirection: Directionality.of(context),
                              end: 0,
                              top: 0,
                              child: Align(
                                  alignment: FractionalOffset.topCenter,
                                  child: topLeftArea)),
                        Consumer(builder: (context, WidgetRef ref, child) {
                          AsyncValue<ConnectivityResult> connectivity =
                              ref.watch(connectivityProvider);

                          NetworkProvider()
                              .pageAlertNoConnectivity(context, connectivity);
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget userTitle(context) {
    BeUser user = BeUserController().user;
    if (isHome != true && (user.name ?? '').isEmptyBe) {
      Navigator.pushNamed(context, "home");
    }

    return Text(
      '${"hi".ctr()} ${user.name ?? ''}',
    );
  }
}
