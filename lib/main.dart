import 'dart:async';
import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cleanedapp/helpers/global_parameters.dart';
import 'package:cleanedapp/helpers/route.dart';
import 'package:cleanedapp/helpers/locator.dart';
import 'package:cleanedapp/room/room_list_screen.dart';
import 'package:cleanedapp/theme.dart';
import 'package:cleanedapp/todo/todo_screen.dart';
import 'package:cleanedapp/user/be_user_controller.dart';
import 'package:sharedor/helpers/device.dart';
import 'package:sharedor/helpers/dynamic_link_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sharedor/helpers/global_parameters.dart';
import 'package:sharedor/helpers/secureStorage.dart';
import 'package:sharedor/widgets/export_widgets.dart';
import 'package:translator/translator.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  await PreferenceUtils().init();
  final translator = GoogleTranslator();

// global RouteObserver
  final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();
  await GlobalParametersFM().setGlobalParameters({
    "navigatorKey": _navigatorKey,
    "routeObserver": routeObserver,
    "familyId": "12345"
  });
  BeUserController().init();
  final value = FirebaseFirestore.instance;
  value.settings = const Settings(
      persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
//   try {
//  //   PreferenceUtils();
//     // await SystemSettingsController().setSystemSettings();
//   } catch (e) {
//   }
  await setupServices();
  // await locator.get<UserController>().setCurrentUser(familyid: "12345");
  // await FirebaseUserRoomsRepository(userid: "123").addInitialRoomsList();
  runApp(EasyLocalization(
      supportedLocales: const [
        Locale('he'),
        Locale('en'),
        Locale('ar'),
        Locale('he', 'IL')
      ],
      path: 'assets/translations/app.csv',
      assetLoader: CsvAssetLoader(),
      startLocale: Locale(PreferenceUtils().getLanguage() ?? "en"),
      //startLocale: Localizations.localeOf(context),
      // path:
      //     'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en'),
      child: ProviderScope(child: FamilyMMenuApp())));
}

class FamilyMMenuApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _FamilyMMenuApp? state = context.findAncestorStateOfType<_FamilyMMenuApp>();
    state?.setLocale(newLocale);
  }

  static String? getLocale(BuildContext context) {
    _FamilyMMenuApp? state = context.findAncestorStateOfType<_FamilyMMenuApp>();
    return state?.getLocale;
  }

  bool isNoConnectivityMessageIsDisplayedNow = false;
  @override
  _FamilyMMenuApp createState() => _FamilyMMenuApp();
}

class _FamilyMMenuApp extends State<FamilyMMenuApp>
    with WidgetsBindingObserver {
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  ConnectivityResult? _connectionStatus;
  Locale? _locale;
  String? get getLocale => _locale?.languageCode;

  setLocale(Locale locale) {
    context.setLocale(locale); // change `easy_localization` locale

    setState(() {
      _locale = locale;
    });
  }

  void handleDynamicLinks() {
    _timerLink = Timer(
      const Duration(milliseconds: 100),
      () async {
        _dynamicLinkService.retrieveDynamicLink().then((_) {
          if (_dynamicLinkService.queryFromLink != null) {
            Map<String, dynamic> linkParams = _dynamicLinkService.queryFromLink;
            NavigatorState navigator = Navigator.of(context);
            BeRouter.handleDeepLinks(linkParams, navigator);
          }
        });
      },
    );
  }

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Timer? _timerLink;
  @override
  void initState() {
    super.initState();

//     String languageCode = Localizations.localeOf(context).languageCode;
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      setState(() {
        _connectionStatus = result;
      });
    });
    handleDynamicLinks();
    WidgetsBinding.instance.addObserver(this);
    try {
      NetworkProvider().initConnectivity(_connectivity);
    } catch (e) {
      showAlertDialog(e.toString(), context);
      return;
    }
  }

  @override
  void didChangeDependencies() async {
    String? locale = FamilyMMenuApp.getLocale(context);
    if (locale != null) {
      setState(() {
        _locale = Locale(locale);
      });
    }
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      handleDynamicLinks();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timerLink?.cancel();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Widget splashScreen = SplashScreen();

    return ProviderScope(
      child: MaterialApp(
          // navigatorObservers: [
          //   SentryNavigatorObserver(),
          // ],
          debugShowCheckedModeBanner: false,
          onGenerateRoute: BeRouter.generateRoute,
          //navigatorKey: GlobalKey<NavigatorState>(),
          navigatorKey: _navigatorKey,
          localizationsDelegates: context.localizationDelegates +
              [
                //FormBuilderLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
          supportedLocales: context.supportedLocales,
          theme: CustomTheme(context).beMemberTheme,
          title: ('Welcome to Clean App'),
          locale: context.locale,
          home: AnimatedSplashScreen(
              backgroundColor: Colors.white,
              duration: 2500,
              splashIconSize: GlobalParametersFM().screenSize.height,
              nextScreen: ToDoScreen(),
              splash: SizedBox.shrink())),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
