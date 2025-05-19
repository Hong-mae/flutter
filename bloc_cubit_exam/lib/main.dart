import 'package:bloc_cubit_exam/count_bloc.dart';
import 'package:bloc_cubit_exam/count_cubit.dart';
import 'package:bloc_cubit_exam/count_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'flutter demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => CountBloc(),
        child: const CountViewPage(),
      ),
    );
  }
}
