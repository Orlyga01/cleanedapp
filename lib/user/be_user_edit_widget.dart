import 'package:cleanedapp/export_all_ui.dart';
import 'package:cleanedapp/misc/providers.dart';
import 'package:cleanedapp/user/be_user_controller.dart';
import 'package:cleanedapp/user/be_user_model.dart';
import 'package:flutter/material.dart';
import 'package:sharedor/export_common.dart';
import 'package:sharedor/external_export_view.dart';
import 'package:sharedor/helpers/export_helpers.dart';
import 'package:sharedor/widgets/shared_form_fields.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BeUserEditWidget extends StatefulWidget {
  late BeUser user;
  bool needToaddUser = true;
  bool userWasAddedOrLoaded = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BeUserEditWidget({
    Key? key,
  })  : user = BeUserController().user,
        super(key: key);

  @override
  State<BeUserEditWidget> createState() => _BeUserEditWidgetState();
}

class _BeUserEditWidgetState extends State<BeUserEditWidget> {
  bool showName = false;

  @override
  Widget build(BuildContext context) {
    bool initialState = widget.user.name.isEmptyBe;
    return initialState
        ? Form(
            key: widget._formKey,
            child: IntrinsicHeight(
              child: Container(
                //  height: showName ? 250 : 100,
                padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                decoration: StyleF.fromBox,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(children: [
                          PhoneField(context,
                              withLable: false,
                              bgTransparent: true, onChanged: (String value) {
                            widget.user.phoneNo = value;
                          }),
                          if (showName)
                            Column(
                              children: [
                                NameField(context,
                                    withLable: false, bgTransparent: true,
                                    onChanged: (String value) {
                                  widget.user.name = value;
                                }),
                                Text(
                                  "Please set your name and we are good to go"
                                      .ctr(),
                                ),
                              ],
                            ),
                        ]),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10)),
                              onPressed: () async {
                                bool? isValid =
                                    widget._formKey.currentState?.validate();

                                if (isValid == true) {
                                  try {
                                    // the get function in the controller would also set the user in a the controller
                                    BeUser? user = await BeUserController()
                                        .get(widget.user.phoneNo);
                                    //if the phonenumber (which is actually the user) is not found
                                    if (user == null) {
                                      // the name is shown that means that we suppose to have all information to save the user
                                      if (showName) {
                                        user = await BeUserController()
                                            .add(widget.user);
                                        // widget should not be visible any more
                                        if (user != null) {
                                          setUser(user);
                                        }
                                      } else {
                                        widget.needToaddUser = true;
                                        setState(() {
                                          showName = true;
                                        });
                                      }
                                    } else {
                                      //User was found we can hide this widget
                                      setUser(user);
                                    }
                                  } catch (e) {
                                    showAlertDialog(
                                      e.toString(),
                                      context,
                                    );
                                  }
                                }
                              },
                              child: Text("Start".ctr())),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Text(
              '${"hi".ctr()} ${widget.user.name ?? ''}',
            ));
  }

  setUser(user) {
    widget.user = user;
    context.read(userStateChanged.notifier).setNotifyUserChange();
    setState(() {});
  }
}
