import 'dart:async';

import 'package:cleanedapp/helpers/global_parameters.dart';
import 'package:cleanedapp/helpers/locator.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:flutter/material.dart';
import 'package:sharedor/export_common.dart';
import 'package:sharedor/helpers/language.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/widgets/radio_buttons.dart';
import 'package:sharedor/widgets/shared_form_fields.dart';

class RoomWidget extends StatefulWidget {
  final Function(Room) onChanged;
  final String? initialValue;
  final bool isChild;
  final bool isRequired;
  final bool readOnly;
  final Room room;
  bool changed = false;
  TextEditingController? controller;
  final bool? checkIfPhoneIsAlreadyInUser;
  GlobalKey<FormState> formKey;
  RoomWidget(
      {Key? key,
      required this.onChanged,
      this.controller,
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
    double screenHeight = locator.get<GlobalParametersFM>().screenSize.height;
    double screenWidth = locator.get<GlobalParametersFM>().screenSize.width;

    Timer? _debounce;
    _onSearchChanged() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (widget.changed) {
          widget.onChanged(widget.room);
          widget.changed = false;
        }
      });
    }

    @override
    void dispose() {
      _debounce?.cancel();
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
        ),
        const SizedBox(height: 10),
        TextFormField(
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

    return Form(
        key: widget.formKey,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemCount: lw.length,
            itemBuilder: (BuildContext context, int index) {
              return lw[index];
            }));
  }
}
