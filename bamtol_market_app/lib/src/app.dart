import 'package:bamtol_market_app/main.dart';
import 'package:bamtol_market_app/screen/init_start_page.dart';
import 'package:bamtol_market_app/screen/splash_page.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late bool isInitStarted;

  @override
  void initState() {
    super.initState();
    isInitStarted = prefs.getBool("isInitStarted") ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return isInitStarted
        ? InitStartPage(
          onStart: () {
            setState(() {
              isInitStarted = false;
            });
            prefs.setBool('isInitStarted', isInitStarted);
          },
        )
        : const SplashPage();
  }
}

// class App extends StatefulWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: Image.asset("assets/images/logo_simbol.png")),
//     );
//   }
// }

// class
