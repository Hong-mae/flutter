import 'package:bamtol_market_app/controllers/authentication_controller.dart';
import 'package:bamtol_market_app/controllers/data_load_controller.dart';
import 'package:bamtol_market_app/firebase_options.dart';
import 'package:bamtol_market_app/pages/app.dart';
import 'package:bamtol_market_app/controllers/splash_controller.dart';
import 'package:bamtol_market_app/pages/home_page.dart';
import 'package:bamtol_market_app/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "당근마켓 클론 코딩",
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Color(0xff212123),
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        scaffoldBackgroundColor: const Color(0xff212123),
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(SplashController());

        Get.put(DataLoadController());
        Get.put(AuthenticationController());
      }),
      getPages: [
        GetPage(name: '/', page: () => const App()),
        GetPage(name: "/home", page: () => const HomePage()),
        GetPage(name: '/login', page: () => const LoginPage()),
      ],
    );
  }
}
