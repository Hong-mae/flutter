import 'package:flutter/material.dart';

class Btn extends StatelessWidget {
  final Widget child;
  final Function() onTap;
  final EdgeInsets padding;
  final Color color;

  const Btn({
    super.key,
    required this.child,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    this.color = const Color(0xffed7738),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Container(
          padding: padding,
          color: color,
          child: child,
        ),
      ),
    );
  }
}
