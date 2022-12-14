import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sharedor/style.dart';

class StyleF {
  static const Color main = Color.fromRGBO(7, 153, 168, 1);
  static const Color darkermain = Color.fromRGBO(7, 153, 168, 1);
  static const Color bgForm = Color(0xFFE0F2F1);
  var x = Colors.blueGrey;

  // ignore: constant_identifier_names
  static const TextStyle H3 = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: main,
      decoration: TextDecoration.none);
  static const TextStyle inkWell = TextStyle(
    color: darkermain,
    fontSize: 18,
  );
  static TextStyle menuTitle = GoogleFonts.parisienne().copyWith(
      fontSize: 30,
      decorationThickness: 6,
      decorationStyle: TextDecorationStyle.solid,
      color: BeStyle.textColor,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline);
  static const TextStyle niceTitle = TextStyle(
    color: darkermain,
    fontSize: 20,
  );
  static const BoxDecoration fromBox = BoxDecoration(
      color: StyleF.bgForm,
      border:
          Border.symmetric(horizontal: BorderSide(color: StyleF.darkermain)));
  static const TextStyle inputLabel =
      TextStyle(color: main, fontSize: 14, fontWeight: FontWeight.w600);
  static Map<String, dynamic> thinDivider = {
    "thickness": 0.5,
    "color": BeStyle.textColor,
  };
  static BoxDecoration roundedBox = BoxDecoration(
      border: Border.all(color: main),
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(30)));
}
