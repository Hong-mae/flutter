import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime firstDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DDay(onHeartPressed: onHeartPressed, firstDay: firstDay),
            _CoupleImage(),
          ],
        ),
      ),
    );
  }

  void onHeartPressed() {
    // setState(() {
    //   firstDay = firstDay.subtract(Duration(days: 1));
    // });
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        final formatDate = DateFormat("yyyy-mm-dd").parse(
          "${firstDay.year}-${firstDay.month}-${firstDay.day}"
        );
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            height: 300,
            child: CupertinoDatePicker(
              onDateTimeChanged: (DateTime date) {
                setState(() {
                  firstDay = date;
                });
              },
              mode: CupertinoDatePickerMode.date,
              initialDateTime: formatDate,
              maximumDate: firstDay,
              maximumYear: firstDay.year,
            ),
          ),
        );
      },
      barrierDismissible: true,
    );
  }
}

class _DDay extends StatelessWidget {
  final GestureTapCallback onHeartPressed;
  final DateTime firstDay;

  const _DDay({required this.onHeartPressed, required this.firstDay});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();

    return Column(
      children: [
        const SizedBox(height: 16),
        Text("U&I", style: textTheme.displayLarge),
        const SizedBox(height: 16),
        Text("우리 처음 만난 날", style: textTheme.bodyLarge),
        Text(
          "${firstDay.year}.${firstDay.month}.${firstDay.day}",
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        IconButton(
          onPressed: onHeartPressed,
          icon: Icon(Icons.favorite, color: Colors.pinkAccent),
          iconSize: 60,
        ),
        const SizedBox(height: 16),
        Text(
          "D+${DateTime(now.year, now.month, now.day).difference(firstDay).inDays + 1}",
          style: textTheme.displayMedium,
        ),
      ],
    );
  }
}

class _CoupleImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Image.asset(
          'assets/img/middle_image.png',
          height: MediaQuery.of(context).size.height / 2,
        ),
      ),
    );
  }
}
