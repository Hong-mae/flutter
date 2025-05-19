class ScheduleModel {
  final String id;
  final String content;
  final DateTime date;
  final int start_time;
  final int end_time;

  ScheduleModel({
    required this.id,
    required this.content,
    required this.date,
    required this.start_time,
    required this.end_time,
  });

  ScheduleModel.fromJson({required Map<String, dynamic> json})
    : id = json['id'],
      content = json['content'],
      date = DateTime.parse(json['date']),
      start_time = json['start_time'],
      end_time = json['end_time'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'date':
          '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
      'start_time': start_time,
      'end_time': end_time,
    };
  }

  ScheduleModel copyWith({
    String? id,
    String? content,
    DateTime? date,
    int? start_time,
    int? end_time,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      content: content ?? this.content,
      date: date ?? this.date,
      start_time: start_time ?? this.start_time,
      end_time: end_time ?? this.end_time,
    );
  }
}
