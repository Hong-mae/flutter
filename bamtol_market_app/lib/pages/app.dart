import 'package:bamtol_market_app/main.dart';
import 'package:bamtol_market_app/pages/init_start_page.dart';
import 'package:bamtol_market_app/pages/splash_page.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() {
    return _App();
  }
}

class _App extends State<App> {
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
