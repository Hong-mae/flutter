import "package:calendar_scheduler/component/main_calendar.dart";
import "package:calendar_scheduler/component/schedule_bottom_sheet.dart";
import "package:calendar_scheduler/component/schedule_card.dart";
import "package:calendar_scheduler/component/today_banner.dart";
import "package:calendar_scheduler/const/colors.dart";
import "package:calendar_scheduler/model/schedule_model.dart";
import "package:calendar_scheduler/provider/schedule_provider.dart";
import "package:calendar_scheduler/utils/logger.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final provider =
        context.read<ScheduleProvider>(); // ➋ 프로바이더 변경이 있을 때마다 build() 함수 재실행
    provider.getSchedules(date: selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<ScheduleProvider>(); // ➋ 프로바이더 변경이 있을 때마다 build() 함수 재실행
    final selectedDate = provider.selectedDate; // ➌ 선택된 날짜 가져오기
    final schedules = provider.cache[selectedDate] ?? [];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(selectedDate: selectedDate),
            isScrollControlled: true,
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: (selectedDate, focusedDate) {
                return onDaySelected(selectedDate, focusedDate, context);
              },
            ),
            // SizedBox(height: 8.0),
            // StreamBuilder<QuerySnapshot>(
            //   stream:
            //       FirebaseFirestore.instance
            //           .collection('schedule')
            //           .where(
            //             'date',
            //             isEqualTo:
            //                 '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}',
            //           )
            //           .snapshots(),
            //   builder: (context, snapshot) {
            //     return TodayBanner(
            //       selectedDate: selectedDate,
            //       count: snapshot.data?.docs.length ?? 0,
            //     );
            //   },
            // ),
            TodayBanner(
              // ➊ 배너 추가하기
              selectedDate: selectedDate,
              count: 0,
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];

                  return Dismissible(
                    key: ObjectKey(schedule.id),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (DismissDirection direction) {
                      provider.deleteSchedule(
                        date: selectedDate,
                        id: schedule.id,
                      ); // ➊
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: ScheduleCard(
                        startTime: schedule.startTime,
                        endTime: schedule.endTime,
                        content: schedule.content,
                      ),
                    ),
                  );
                },
              ),
              // child: StreamBuilder<QuerySnapshot>(
              //   stream:
              //       FirebaseFirestore.instance
              //           .collection('schedule')
              //           .where(
              //             'date',
              //             isEqualTo:
              //                 '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}',
              //           )
              //           .snapshots(),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasError) {
              //       return Center(child: Text("일정 정보를 가져오지 못했습니다."));
              //     }

              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Container();
              //     }

              //     final schedules =
              //         snapshot.data!.docs
              //             .map(
              //               (QueryDocumentSnapshot e) => ScheduleModel.fromJson(
              //                 json: (e.data() as Map<String, dynamic>),
              //               ),
              //             )
              //             .toList();

              //     return ListView.builder(
              //       itemCount: schedules.length,
              //       itemBuilder: (context, index) {
              //         final schedule = schedules[index];

              //         return Dismissible(
              //           key: ObjectKey(schedule.id),
              //           direction: DismissDirection.endToStart,
              //           onDismissed: (DismissDirection direction) {
              //             FirebaseFirestore.instance
              //                 .collection('schedule')
              //                 .doc(schedule.id)
              //                 .delete();
              //           },
              //           child: Padding(
              //             padding: const EdgeInsets.only(
              //               bottom: 8.0,
              //               left: 8.0,
              //               right: 8.0,
              //             ),
              //             child: ScheduleCard(
              //               startTime: schedule.startTime,
              //               endTime: schedule.endTime,
              //               content: schedule.content,
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDate,
    BuildContext context,
  ) {
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(date: selectedDate);
    provider.getSchedules(date: selectedDate);

    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
