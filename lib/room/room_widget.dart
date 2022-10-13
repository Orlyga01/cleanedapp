import 'dart:async';

import 'package:cleanedapp/helpers/global_parameters.dart';
import 'package:cleanedapp/helpers/locator.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:flutter/material.dart';
import 'package:sharedor/export_common.dart';
import 'package:sharedor/helpers/language.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/widgets/radio_buttons.dart';

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

    return Form(
      key: widget.formKey,
      child: Container(
        height: screenHeight,
        child: Column(
          children: [
            if (!widget.readOnly)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Edit Room".ctr(), style: BeStyle.H2),
              ),
            Flexible(
              child: RadioButtonWidget(
                selectedItem: widget.room.type,
                items: RoomType.values,
                screenWidth: screenWidth,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
                // initialValue: initialValue,
                readOnly: widget.readOnly,
                decoration: InputDecoration(
                  hintText: ("Title".ctr()),
                  fillColor:
                      widget.readOnly ? Colors.transparent : Colors.white,
                ),
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
            TextFormField(
              maxLines: 2, //or null
              // initialValue: initialValue,
              readOnly: widget.readOnly,
              decoration: InputDecoration(
                hintText: ("Description".ctr()),
                fillColor: widget.readOnly ? Colors.transparent : Colors.white,
              ),
              onChanged: (value) =>
                  {widget.room.description = value, _onSearchChanged()},
            ),
          ],
        ),
      ),
    );
  }
}
// class RoomWidget extends StatelessWidget {
//   final Function(Room) onChanged;
//   final String? initialValue;
//   final bool isChild;
//   final bool isRequired;
//   final bool readOnly;
//   final Room room;
//   TextEditingController? controller;
//   final bool? checkIfPhoneIsAlreadyInUser;
//   //GlobalKey<FormState> formKey;
//   Key formKey;
//   RoomWidget(
//       {Key? key,
//       required this.onChanged,
//       this.controller,
//       this.initialValue,
//       this.isChild = false,
//       this.isRequired = false,
//       this.checkIfPhoneIsAlreadyInUser,
//       required this.formKey,
//       this.readOnly = false,
//       Room? room})
//       : room = room ?? Room.empty,
//         super(key: key);
//   String? phoneExists;
//   String? phone;

//   @override
//   Widget build(BuildContext context) {
//     Timer? _debounce;
//     _onSearchChanged() {
//       if (_debounce?.isActive ?? false) _debounce?.cancel();
//       _debounce = Timer(const Duration(milliseconds: 500), () {
//         onChanged(room);
//       });
//     }

//     @override
//     void dispose() {
//       _debounce?.cancel();
//     }

//     return Form(
//       key: formKey,
//       child: Column(
//         children: [
//           TextFormField(
//               controller: controller,
//               // initialValue: initialValue,
//               readOnly: readOnly,
//               decoration: InputDecoration(
//                 hintText: ("Title".ctr()),
//                 fillColor: readOnly ? Colors.transparent : Colors.white,
//               ),
//               onChanged: (value) => {room.title = value, _onSearchChanged()},
//               validator: (value) {
//                 if (isRequired && (value.isEmptyBe)) {
//                   return "Please add the title".ctr();
//                 }
//               }),
//           TextFormField(
//             controller: controller,
//             maxLines: 8, //or null
//             // initialValue: initialValue,
//             readOnly: readOnly,
//             decoration: InputDecoration(
//               hintText: ("Description".ctr()),
//               fillColor: readOnly ? Colors.transparent : Colors.white,
//             ),
//             onChanged: (value) =>
//                 {room.description = value, _onSearchChanged()},
//           ),
//         ],
//       ),
//     );
//   }
// }
