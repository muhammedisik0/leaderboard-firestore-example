import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
  const Circle({
    Key? key,
    required this.color,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  final Color color;
  final Color iconColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: color,
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.color_lens,
          color: iconColor,
          size: 44,
        ),
      ),
    );
  }
}
