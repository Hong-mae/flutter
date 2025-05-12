import 'package:flutter/material.dart';
import 'package:blog_web_app/screen/home_screen.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    )
  );
}