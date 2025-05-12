import 'package:flutter/material.dart';
import 'package:widget_prj2/ColumnWidgetExam.dart';
import 'package:widget_prj2/RowWidgetExam.dart';

void main() {
  runApp(ColumnWidgetExam());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: () => print('on tap'),
            onDoubleTap: () => print('on double tap'),
            onLongPress: () => print('on long press'),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              width: 100.0,
              height: 100.0,
            ),
          ),
        ),
      ),
    );
  }
}

