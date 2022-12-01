import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/buttom_navbar.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/services/notification_service.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';
import 'package:viicsoft_inventory_app/services/provider/authentication.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';
import 'package:viicsoft_inventory_app/ui/event/add_event_page.dart';
import 'package:viicsoft_inventory_app/ui/store/add_equipment_page.dart';
import 'package:viicsoft_inventory_app/ui/Menu/user_profile/reset_password_page.dart';
import 'package:viicsoft_inventory_app/ui/authentication/login_screen.dart';
import 'package:viicsoft_inventory_app/ui/authentication/loginsignup_screen.dart';
import 'package:viicsoft_inventory_app/ui/authentication/signup_screen.dart';
import 'package:viicsoft_inventory_app/ui/event/events_page.dart';
import 'package:viicsoft_inventory_app/ui/home_page.dart';
import 'package:viicsoft_inventory_app/ui/store/store_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await NotificationService().init();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Authentication()),
    ChangeNotifierProvider(create: (_) => UserData()),
    ChangeNotifierProvider(create: (_) => AppData()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final GlobalKey<FormState> navigatorKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColor.primaryColor,
        ),
        fontFamily: 'Poppins',
      ),
      title: 'Inventory App',
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? '/'
          : '/myButtomNavigationBar',
      routes: {
        '/': (context) => const SignupLogin(),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const Login(),
        '/homePage': (context) => const HomePage(),
        '/addItem': (context) => const AddEquipmentPage(),
        '/addevent': (context) => const AddEventPage(),
        '/resetpassword': (context) => const ResetPasswordPage(),
        '/event': (context) => const EventsPage(),
        '/store': (context) => const StorePage(),
        '/myButtomNavigationBar': (context) => const MyButtomNavigationBar()
      },
    );
  }
}
