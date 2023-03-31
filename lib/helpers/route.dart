import 'package:cleanedapp/room/room_list_screen.dart';
import 'package:cleanedapp/misc/room_tasks_screen.dart';
import 'package:cleanedapp/user/be_user_controller.dart';
import 'package:cleanedapp/user/be_user_model.dart';
import 'package:cleanedapp/user/user_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharedor/helpers/dynamic_link_service.dart';
import 'package:sharedor/helpers/export_helpers.dart';
import 'package:sharedor/widgets/export_widgets.dart';

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
      case "backofficerooms":
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return RoomListScreen();
          },
        );
      case "userscreen":
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return UserScreen();
          },
        );
      case "backofficeroom":
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return BackOfficeRoomScreen(roomId: args?["roomid"] ?? '');
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
    BeUser user = BeUserController().user;
    bool isLoggedIn = (user.name ?? '').isEmpty;
// We need to store the information berfore continueing
    if (!isLoggedIn) {
      try {
        await PreferenceUtils().mapToStorage("actionForAfterLogIn", params);
      } catch (e) {
        if (kDebugMode) {
          print("problem with storage: $e");
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


