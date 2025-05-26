import 'package:flutter/material.dart';

class DiceFace extends StatelessWidget {
  final int value;
  final bool isHeld;
  final VoidCallback onTap;

  const DiceFace({
    super.key,
    required this.value,
    required this.isHeld,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: isHeld ? Colors.grey[800] : null,
          border: Border.all(
            color: isHeld ? Colors.amber : Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          value.toString(),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
