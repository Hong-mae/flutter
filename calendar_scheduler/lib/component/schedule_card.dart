import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final int start_time;
  final int end_time;
  final String content;

  const ScheduleCard({
    super.key,
    required this.start_time,
    required this.end_time,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: PRIMARY_COLOR),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time(start_time: start_time, end_time: end_time),
              SizedBox(width: 16.0),
              _Content(content: content),
              SizedBox(width: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final int start_time;
  final int end_time;

  const _Time({required this.start_time, required this.end_time});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: PRIMARY_COLOR,
      fontSize: 16.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${start_time.toString().padLeft(2, '0')}:00", style: textStyle),
        Text(
          "${end_time.toString().padLeft(2, '0')}:00",
          style: textStyle.copyWith(fontSize: 10.0),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content;

  const _Content({required this.content});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Text(content));
  }
}
