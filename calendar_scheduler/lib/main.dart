import 'package:calendar_scheduler/screen/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: "url", anonKey: "key");

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting();

  // final scheduleRepository = ScheduleRepository();
  // final authRepository = AuthRepository();
  // final scheduleProvider = ScheduleProvider(
  //   authRepository: authRepository,
  //   scheduleRepository: scheduleRepository,
  // );

  runApp(
    // ChangeNotifierProvider(
    //   create: (_) => scheduleProvider,
    //   child: MaterialApp(home: AuthScreen()),
    // ),
    MaterialApp(debugShowCheckedModeBanner: false, home: AuthScreen()),
  );
}
