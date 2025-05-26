import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDate;
  final int count;

  const TodayBanner({
    super.key,
    required this.selectedDate,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    // final provider = context.watch<ScheduleProvider>();

    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.white,ss
    );

    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일', // “년 월 일” 형태로 표시
                style: textStyle,
              ),
            ),
            Text(
              '$count개', // 일정 개수 표시
              style: textStyle,
            ),
            const SizedBox(width: 8.0),
            GestureDetector(
              onTap: () async {
                // await GoogleSignIn().signOut();
                // await FirebaseAuth.instance.signOut();

                await Supabase.instance.client.auth.signOut();

                Navigator.of(context).pop();
              },
              child: Icon(Icons.logout, size: 16.0, color: Colors.white),
            ),
            // Text(
            //   "${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일",
            //   style: textStyle,
            // ),
            // Row(
            //   children: [
            //     Text("$count개", style: textStyle),
            //     const SizedBox(width: 8.0),
            //     GestureDetector(
            //       onTap: () {
            //         provider.logout();

            //         Navigator.of(context).pop();
            //       },
            //       child: Icon(Icons.logout, color: Colors.white, size: 16.0),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
