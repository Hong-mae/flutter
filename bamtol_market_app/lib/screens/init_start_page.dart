import 'package:flutter/material.dart';

class InitStartPage extends StatelessWidget {
  const InitStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('초기 소개 페이지', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
