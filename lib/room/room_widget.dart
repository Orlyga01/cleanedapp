import 'dart:async';

import 'package:cleanedapp/export_all_ui.dart';
import 'package:cleanedapp/helpers/global_parameters.dart';
import 'package:cleanedapp/helpers/locator.dart';
import 'package:cleanedapp/misc/providers.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:cleanedapp/user/be_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:sharedor/export_common.dart';
import 'package:sharedor/external_export_view.dart';
import 'package:sharedor/helpers/language.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/widgets/radio_buttons.dart';
import 'package:sharedor/widgets/shared_form_fields.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class RoomWidget extends StatefulWidget {
  final Function(Room)? onChanged;
  final String? initialValue;
  final bool isChild;
  final bool isRequired;
  bool readOnly;
  final Room room;
  bool changed = false;
  final bool? checkIfPhoneIsAlreadyInUser;
  GlobalKey<FormState> formKey;
  RoomWidget(
      {Key? key,
      this.onChanged,
      this.initialValue,
      this.isChild = false,
      this.isRequired = false,
      this.checkIfPhoneIsAlreadyInUser,
      required this.formKey,
      this.readOnly = false,
      Room? room})
      : room = room ?? Room.empty,
        super(key: key);

  @override
  State<RoomWidget> createState() => _RoomWidgetState();
}

class _RoomWidgetState extends State<RoomWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = locator.get<GlobalParametersFM>().screenSize.width;

    Timer? debounce;
    _onSearchChanged() {
      if (debounce?.isActive ?? false) debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        if (widget.changed && widget.onChanged != null) {
          widget.onChanged!(widget.room);
          widget.changed = false;
        }
      });
    }

    @override
    void dispose() {
      debounce?.cancel();
      //widget.formKey = null;
      super.dispose();
    }

    List<Widget> lw;
    if (widget.readOnly) {
      lw = [
        LabelAndField(
            label: "Type".ctr(),
            icon: RoomTypes[widget.room.type]!.icon ?? Icons.abc_outlined,
            value: RoomTypes[widget.room.type]!.name!),
        LabelAndField(
            label: "Description".ctr(), value: widget.room.description),
      ];
    } else {
      lw = [
        RadioButtonWidget(
            selectedItem: widget.room.type,
            items: RoomType.values,
            screenWidth: screenWidth,
            onChange: (value) => {
                  widget.changed = true,
                  widget.room.type = value,
                  setDefaultTitle(),
                  _onSearchChanged()
                }),
        const SizedBox(height: 10),
        TextFormField(
            key: GlobalKey(),
            // initialValue: initialValue,
            enabled: !widget.readOnly,
            initialValue: widget.room.title,
            decoration: InputDecoration(
              labelText: "Title".ctr(),
            ).unifiedLabel(readOnly: widget.readOnly),
            onChanged: (value) => {
                  widget.changed = true,
                  widget.room.title = value,
                  _onSearchChanged()
                },
            validator: (value) {
              if (value.isEmptyBe) {
                return "Please add the title".ctr();
              }
              return null;
            }),
        const SizedBox(height: 10),
        if (!(widget.readOnly && widget.room.description.isEmptyBe))
          TextFormField(
            maxLines: 2, //or null
            // initialValue: initialValue,
            enabled: !widget.readOnly,
            initialValue: widget.room.description,

            decoration: InputDecoration(
              labelText: "Description".ctr(),
              fillColor: widget.readOnly ? Colors.transparent : Colors.white,
            ).unifiedLabel(readOnly: widget.readOnly),
            onChanged: (value) =>
                {widget.room.description = value, _onSearchChanged()},
          ),
      ];
    }

    return Column(
      children: [
        Stack(
          children: [
            Form(
                key: widget.formKey,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: widget.readOnly ? null : StyleF.fromBox,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: lw.length,
                      itemBuilder: (BuildContext context, int index) {
                        return lw[index];
                      }),
                )),
            if (widget.readOnly) actionBar()
          ],
        ),
        if (!widget.readOnly)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                  child: Text(
                    "Cancel".ctr(),
                  ),
                  onPressed: () {}),
              ElevatedButton(
                  child: Text("Done".ctr()),
                  onPressed: () async {
                    bool success = await saveRoom(widget.room, context);
                  }),
            ],
          )
      ],
    );
  }

  Future<bool> saveRoom(Room room, BuildContext context,
      {bool? addMode = false}) async {
    print(room.type);
    bool? isValid;
    isValid = widget.formKey.currentState?.validate();
    if (isValid == false) return false;
    try {
      await BeUserController().updateRoomOfUser(room);
      context.read(userStateChanged.notifier).setNotifyUserChange();

      setState(() {});
    } catch (e) {
      showAlertDialog(e.toString(), context);
      return false;
    }
    return true;
  }

  setDefaultTitle() {
    widget.room.title = enumToString(widget.room.type.toString());
    setState(() {});
  }

  Widget actionBar() {
    return Positioned.directional(
        textDirection: Directionality.of(context),
        end: 0,
        top: 0,
        child: Align(
          alignment: FractionalOffset.bottomCenter,
        ));
  }
}
