import 'package:cleanedapp/main.dart';
import 'package:cleanedapp/misc/style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sharedor/export_common.dart';

class CustomTheme {
  // ignore: prefer_typing_uninitialized_variables
  final context;
  CustomTheme(this.context);
  ThemeData get beMemberTheme {
    //#D46BE7

    Map<int, Color> color = {
      50: const Color.fromRGBO(7, 153, 168, .1),
      100: const Color.fromRGBO(7, 153, 168, .2),
      200: const Color.fromRGBO(7, 153, 168, .3),
      300: const Color.fromRGBO(7, 153, 168, .4),
      400: const Color.fromRGBO(7, 153, 168, .5),
      500: const Color.fromRGBO(7, 153, 168, .6),
      600: const Color.fromRGBO(7, 153, 168, .7),
      700: const Color.fromRGBO(7, 153, 168, .8),
      800: const Color.fromRGBO(7, 153, 168, .9),
      900: const Color.fromRGBO(7, 153, 168, 1),
    };
    //final Color main = Colors.red;

    // ignore: non_constant_identifier_names
    TextTheme TextThemeLang = Theme.of(context)
        .textTheme
        .apply(
          //  bodyColor: StyleF.darkermain.darken(0.1),
          bodyColor: BeStyle.textColor,
          displayColor: BeStyle.textColor,

          // fontSizeFactor: 1.1,
          // fontSizeDelta: 2.0,
        )
        .copyWith(subtitle1: const TextStyle(fontWeight: FontWeight.w600));
    switch (FamilyMMenuApp.getLocale(context)) {
      case "he":
        TextThemeLang = GoogleFonts.varelaRoundTextTheme(TextThemeLang);
        break;

      default:
        TextThemeLang = GoogleFonts.assistantTextTheme(TextThemeLang);
    }

    return ThemeData(
        //  fontFamilyM: 'Poppins',

        //  textTheme: GoogleFonts.assistantTextTheme(Theme.of(context).textTheme).copyWith(),

        //primaryColor: StyleF.darkermain,
        primaryColor: StyleF.darkermain,
        primarySwatch: MaterialColor(0xFF0098A7, color),
        // highlightColor: BeStyle.mainMiddle,
        // listTileTheme: const ListTileThemeData(
        //     //contentPadding: EdgeInsets.all(0),
        //     : true),
        textTheme: TextThemeLang,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            size: BeStyle.smallText * 1.8,
            color: BeStyle.textColorLight,
          ),
          foregroundColor: BeStyle.textColor,
          titleTextStyle:
              TextStyle(fontSize: BeStyle.smallText, color: BeStyle.textColor),
        ),
        scaffoldBackgroundColor: Colors.white,
        hintColor: Colors.grey.shade200,
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          primary: StyleF.darkermain,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        )),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 40),
                primary: StyleF.main,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                side: const BorderSide(
                  color: StyleF.main,
                  width: 1.0,
                ),
                textStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700))),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
          primary: StyleF.darkermain,
          shadowColor: Colors.transparent,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          alignment: Alignment.center,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          side: const BorderSide(
            color: StyleF.main,
            width: 1.0,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        )),
        inputDecorationTheme: const InputDecorationTheme(
            fillColor: Colors.transparent,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: StyleF.main), //<-
            ),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: BeStyle.inputHint,
            labelStyle: BeStyle.inputLabel,

            // focusedBorder: UnderlineInputBorder(
            //     borderSide: BorderSide(color: BeStyle.lightGray)),
            contentPadding: EdgeInsets.only(
              top: 15,
              bottom: 2,
            ),
            suffixStyle: TextStyle(
              color: Colors.white,
            )),
        checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all<Color>(StyleF.darkermain)),
        radioTheme: RadioThemeData(
            visualDensity: const VisualDensity(
              horizontal: -4,
            ),
            fillColor: MaterialStateProperty.all<Color>(StyleF.darkermain)),
        cardTheme: const CardTheme(
            margin: EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        dialogTheme: const DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        toggleableActiveColor: StyleF.darkermain,
        toggleButtonsTheme: const ToggleButtonsThemeData(
            selectedColor: StyleF.darkermain,
            textStyle: TextStyle(fontSize: 18)),
        dividerTheme: const DividerThemeData(color: StyleF.main, thickness: 1));
  }
}
