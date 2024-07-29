import 'package:flutter/material.dart';

class RainbowText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double step;
  final double offset;

  const RainbowText({super.key,
    required this.text,
    required this.style,
    this.step = 0.1,
    this.offset = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue,
            Colors.indigo,
            Colors.purple,
          ],
          stops: [
            0.0,
            0.1,
            0.2,
            0.4,
            0.6,
            0.8,
            1.0,
          ],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
