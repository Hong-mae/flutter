import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_dice/screen/home_screen.dart';
import 'package:random_dice/screen/settings_screen.dart';
import 'package:shake/shake.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? tabController;
  double threshold = 2.7;
  int number = 1;
  ShakeDetector? shakeDetector;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(tabListener);

    shakeDetector = ShakeDetector.autoStart(
      shakeSlopTimeMS: 100,
      shakeThresholdGravity: threshold,
      onPhoneShake: onPhoneShake,
    );
  }

  void onPhoneShake(dynamic _) {
    final rand = Random();

    setState(() {
      number = rand.nextInt(5) + 1;
      print("Shake detected! New number: $number");
    });
  }

  tabListener() {
    setState(() {});
  }

  @override
  void dispose() {
    tabController!.removeListener(tabListener);
    shakeDetector!.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(controller: tabController, children: renderChildren()),
      bottomNavigationBar: renderBottomNavigationBar(),
    );
  }

  List<Widget> renderChildren() {
    return [
      HomeScreen(number: number),
      SettingsScreen(
        threshold: threshold,
        onThresholdChanged: onThresholdChanged,
      ),
    ];
  }

  void onThresholdChanged(double value) {
    setState(() {
      threshold = value;
    });
  }

  BottomNavigationBar renderBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: tabController!.index,
      onTap: (index) {
        setState(() {
          tabController!.animateTo(index);
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.edgesensor_high_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
