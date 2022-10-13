import 'package:flutter/material.dart';

class RoomWidget extends StatelessWidget {
  final Function onChanged;
  final String? initialValue;
  final bool isChild;
  final bool isRequired;
  final bool readOnly;
  TextEditingController? controller;
  final bool? checkIfPhoneIsAlreadyInUser;
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  RoomWidget(
      {Key? key,
      required this.onChanged,
      this.controller,
      this.initialValue,
      this.isChild = false,
      this.isRequired = false,
      this.checkIfPhoneIsAlreadyInUser,
      this.formKey,
      this.readOnly = false})
      : super(key: key);
  String? phoneExists;
  String? phone;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        // initialValue: initialValue,
        readOnly: readOnly,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: ("Mobile Phone"),
          fillColor: readOnly ? Colors.transparent : Colors.white,
        ),
        onChanged: (value) => {onChanged(value), phone = value},
        validator: (value) {
          if (isRequired && (value == null || value.length == 0))
            return "missing phone";
          if (phoneExists != null) {
            return phoneExists;
          }
          onChanged(value);
        });
  }
}
