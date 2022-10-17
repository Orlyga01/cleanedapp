import 'package:authentication/user/providers/import_user.dart';
import 'package:cleanedapp/export_all_ui.dart';
import 'package:cleanedapp/user/be_user_controller.dart';
import 'package:cleanedapp/user/be_user_model.dart';
import 'package:flutter/material.dart';
import 'package:sharedor/export_common.dart';
import 'package:sharedor/external_export_view.dart';
import 'package:sharedor/helpers/export_helpers.dart';
import 'package:sharedor/widgets/shared_form_fields.dart';

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
            child: Container(
              height: showName ? 200 : 100,
              padding: const EdgeInsets.all(8),
              decoration: StyleF.fromBox,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(children: [
                          PhoneField(context,
                              withLable: false,
                              bgTransparent: true, onChanged: (String value) {
                            widget.user.phoneNo = value;
                          }),
                          if (showName)
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                    "Please set your name and we are good to go"
                                        .ctr(),
                                    style: BeStyle.H2),
                                NameField(context,
                                    withLable: false, bgTransparent: true,
                                    onChanged: (String value) {
                                  widget.user.name = value;
                                }),
                              ],
                            ),
                        ]),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
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
                                    await BeUserController().add(widget.user);
                                  } else {
                                    widget.needToaddUser = true;
                                    setState(() {
                                      showName = true;
                                    });
                                  }
                                }
                              } catch (e) {
                                showAlertDialog(
                                  e.toString(),
                                  context,
                                );
                              }
                            }
                          },
                          child: Text("Start".ctr()))
                    ],
                  ),
                ],
              ),
            ),
          )
        : Text('${"hi".ctr()} ${widget.user.name ?? ''}');
  }
}
