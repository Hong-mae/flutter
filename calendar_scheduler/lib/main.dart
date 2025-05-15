import 'package:calendar_scheduler/db/drift_db.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final db = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(db);

  runApp(MaterialApp(home: HomeScreen()));
}
