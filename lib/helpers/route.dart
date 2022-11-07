import 'package:authentication/authenticate/Widgets/forgot_password.dart';
import 'package:authentication/authenticate/Widgets/login_page.dart';
import 'package:authentication/shared/auth_widgets.dart';
import 'package:authentication/user/providers/user_provider.dart';
import 'package:cleanedapp/room/room_list_screen.dart';
import 'package:cleanedapp/misc/room_tasks_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharedor/helpers/dynamic_link_service.dart';
import 'package:sharedor/helpers/export_helpers.dart';

class BeRouter {
  Future<void> routeAfterLogin(context, String? actionOnUser) async {
    try {
      await DynamicLinkService().deepLinkRouting(context);
    } catch (e) {
      showAlertDialog(e.toString(), context);
    }
    Navigator.pushNamed(context, "home");
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map<String, dynamic>? args;
    if (settings.arguments != null) {
      args = settings.arguments as Map<String, dynamic>;
    }
    switch (settings.name) {
      case "login":
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return LoginPage(
              moreInfo: args,
              loginInfo: args?["logininfo"],
            );
          },
        );
      case "reset_password":
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return ForgotPasswordPage(email: args?["email"]);
          },
        );

      case "register":
        // List<CustomInputFields>? listCustomFields =
        //     getRegistrationCustomFields();
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return LoginPage(
              registerMode: true,
              loginInfo: args?["logininfo"],
              //customFields: listCustomFields,
              // doBeforeRegister: (loginInfo) =>
              //     setCustomFieldsInFinalParameters(loginInfo, listCustomFields),
            );
          },
        );
      case "roomlist":
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return RoomListScreen();
          },
        );
      case "tasklist":
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return TaskListScreen(roomId: args?["roomid"]);
          },
        );
      // case "clientlist":
      //   return MaterialPageRoute(
      //     settings: settings,
      //     builder: (context) {
      //       // return CalendarScreen();
      //       return ClientListScreen(momAdded: args?["momAdded"]);
      //     },
      //   );

      // case "profile":
      //   return MaterialPageRoute(
      //       settings: settings,
      //       builder: (context) {
      //         return ProfileScreen(profile: args!["profile"]);
      //       });

      // case "test":
      //   return MaterialPageRoute(
      //       settings: settings,
      //       builder: (context) {
      //         return TestPage();
      //       });
      // case "admin":
      //   return MaterialPageRoute(
      //       settings: settings,
      //       builder: (context) {
      //         return AdminPage();
      //       });

      default:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }

//expecting to find LoginInfo in the params
  static Future<void> handleDeepLinks(
      Map<String, dynamic> params, NavigatorState navigator) async {
    if (params["target"] == null) return;

    bool isLoggedIn = UserController().isUserLoggedIn;
// We need to store the information berfore continueing
    if (!isLoggedIn) {
      try {
        await PreferenceUtils().mapToStorage("actionForAfterLogIn", params);
      } catch (e) {
        if (kDebugMode) {
          print("problem with storage: " + e.toString());
        }
        rethrow;
      }
      params["fromDeepLink"] = true;
      params["registerMode"] = false;
      navigator.pushNamed("register", arguments: params);
      return;
    }
  }
}
