import 'package:flutter/material.dart';

class ColumnWidgetExam extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Container(
                height: 50,
                width: 50,
                color: Colors.red
              ),
              new SizedBox(width: 12,),
              Container(
                height: 50,
                width: 50,
                color: Colors.green
              ),
              new SizedBox(width: 12,),
              Container(
                height: 50,
                width: 50,
                color: Colors.blue
              )
            ],
          ),
        ),
      ),
    );
  }
}