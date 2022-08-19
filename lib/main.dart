import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ssl_monitor/database/model/user/query.dart';
import 'package:ssl_monitor/database/model/user/user.dart';
import 'package:ssl_monitor/screen/auth_screen.dart';
import 'package:ssl_monitor/screen/main_screen.dart';
import 'package:ssl_monitor/utils/functions.dart';
import 'package:ssl_monitor/utils/local_notification.dart';
import 'package:ssl_monitor/utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleFonts.nunito().fontFamily; // Get fontFamily
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  await LocalNotificationService.initialize();

  registerAdapters();

  User? user = await getUser();

  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final User? user;
  const MyApp({
    Key? key,
    this.user,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SSL Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: materialColor,
        fontFamily: fontFamily,
      ),
      home: user == null ? AuthScreen() : MainScreen(),
    );
  }
}
