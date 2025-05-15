import 'package:flutter/material.dart';
import 'point_notification.dart';

class Message extends StatelessWidget {
  final bool alignLeft;
  final String message;
  final int? point;

  const Message({
    super.key,
    required this.alignLeft,
    required this.message,
    this.point,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = alignLeft ? Alignment.centerLeft : Alignment.centerRight;
    final bgColor = alignLeft ? Color(0xfff4f4f4) : Colors.white;
    final border = alignLeft ? Color(0xffe7e7e7) : Colors.black12;

    return Column(
      children: [
        Align(
          alignment: alignment,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.0),
              color: bgColor,
              border: Border.all(color: border, width: 1.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Text(
                message,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
        ),
        if (point != null)
          Align(alignment: alignment, child: PointNotification(point: point!)),
      ],
    );
  }
}
