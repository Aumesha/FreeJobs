import 'package:flutter/material.dart';

class JobIconWidget extends StatelessWidget {
  final double size;
  const JobIconWidget({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.green[700],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.work_rounded,
          color: Colors.white,
          size: size * 0.55,
        ),
      ),
    );
  }
}
