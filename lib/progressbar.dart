import 'package:flutter/material.dart';
//import 'package:nice_buttons/nice_buttons.dart';

class GradientProgressBar extends StatelessWidget {
  final double value;
  final double height;

  const GradientProgressBar({
    Key? key,
    required this.value,
    this.height = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 3, 8, 33),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: FractionallySizedBox(
        widthFactor: value,
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}
