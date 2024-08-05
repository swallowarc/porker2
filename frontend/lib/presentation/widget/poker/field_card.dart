import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FieldCard extends HookConsumerWidget {
  final int index;

  const FieldCard({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 200),
    )..forward();

    final isFront = useState(true);

    void flipCard() {
      if (isFront.value) {
        controller.reverse();
      } else {
        controller.forward();
      }
      isFront.value = !isFront.value;
    }

    final random = Random();
    final tilt = (random.nextDouble() - 0.5) * 0.2;

    return GestureDetector(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final angle = controller.value * pi;
          final transform = Matrix4.rotationY(angle);
          if (angle >= pi / 2) {
            transform.rotateY(pi);
          }
          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Transform(
              transform: Matrix4.rotationZ(tilt),
              child: SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0, 1), end: const Offset(0, 0))
                    .animate(controller),
                child: controller.value <= 0.5
                    ? Card(
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            'Card ${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : const Card(
                        color: Colors.redAccent,
                        child: Center(
                          child: Text(
                            'Back',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
