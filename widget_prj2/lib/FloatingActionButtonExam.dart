import 'package:flutter/material.dart';

class FloatingActionButtonExample extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Text('click'),
          ),
          body: SafeArea(
            child: SizedBox(
              height: 200,
              width: 200,

              child: Container(
                color: Colors.black,
                child: Container(
                  color: Colors.blue,
                  margin: EdgeInsets.all(16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      color: Colors.red,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}