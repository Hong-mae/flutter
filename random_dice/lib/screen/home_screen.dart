import 'package:flutter/material.dart';
import 'package:random_dice/const/colors.dart';

class HomeScreen extends StatelessWidget {
  final int number;

  const HomeScreen({required this.number, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: AnimatedSwitcher(
            duration: Duration(seconds: 10),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: Image.asset("assets/img/$number.png"),
          ),
        ),
        SizedBox(height: 32.0),
        Text(
          "Lucky Number",
          style: TextStyle(
            color: secondaryColor,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.0),
        Text(
          number.toString(),
          style: TextStyle(
            color: primaryColor,
            fontSize: 60.0,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }
}
