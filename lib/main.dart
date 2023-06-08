// @dart=2.9

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indigo_paints/ui/ppb/lot%20pickup/controller/scan_serial_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:indigo_paints/consts/images_const.dart';
import 'package:indigo_paints/consts/methods_const.dart';
import 'package:indigo_paints/consts/string_const.dart';
import 'package:indigo_paints/ui/Notification/controller/notificationController.dart';
import 'package:indigo_paints/ui/login/login_screen.dart';
import 'package:indigo_paints/ui/my_homepage.dart';
import 'package:after_layout/after_layout.dart';
import 'package:indigo_paints/ui/pick/ui/ByBatch/controller/scan_serial_controller.dart';
import 'package:indigo_paints/ui/pick/ui/Verification/scan_verified_controller.dart';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  ByteData data = await PlatformAssetBundle().load('assets/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(
      MultiProvider(
    providers: [
      ChangeNotifierProvider<NotificationClass>(
          create: (_) => NotificationClass()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotificationClass>(
            create: (_) => NotificationClass()),
        ChangeNotifierProvider(create: (_) => SerialController()),
        ChangeNotifierProvider(create: (_) => SerialControllerForLot()),
           ChangeNotifierProvider(create: (_) => VerifiedController()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: StringConst.appName,
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            // textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
          ),
          home: CheckUserLogin()),
    );
  }

  Future<bool> checkUserLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String username = preferences.getString(StringConst.userName);
    String refresh = preferences.getString("access_token");

    if (username == "admin")  {
      return true;
    } else {
      return false;
    }
  }
}

class CheckUserLogin extends StatefulWidget {
  @override
  _CheckUserLoginState createState() => _CheckUserLoginState();
}

class _CheckUserLoginState extends State<CheckUserLogin>
    with AfterLayoutMixin<CheckUserLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImageConst.odLoginPage), fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    checkFirstSeen();
  }

  Future checkFirstSeen() async {
    await SharedPreferences.getInstance().then((value) async {
      bool _logedIn = false;
      if (value.getString(StringConst.userName) != null) {
        _logedIn = true;
      }
      if (_logedIn) {
        // replacePage(HomePage(), context);
      } else {
        replacePage(LoginScreen(), context);
      }
    });
  }
}
