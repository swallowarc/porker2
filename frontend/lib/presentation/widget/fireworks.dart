import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

const defaultEffectConfiguration = EffectConfiguration(
  minAngle: -105,
  maxAngle: -70,
  minDuration: 1200,
  maxDuration: 2100,
  minFadeOutThreshold: 0.15,
  maxFadeOutThreshold: 0.30,
  minBeginScale: 1,
  maxBeginScale: 1,
  minEndScale: 0,
  maxEndScale: 0,
  trail: StraightTrail(
    trailWidth: 3,
    trailProgress: 0.3,
  ),
  minDistance: 300,
  maxDistance: 600,
);

class FireWorks extends StatelessWidget {
  const FireWorks({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Newton(
      activeEffects: [
        ExplodeEffect(
          particleConfiguration: ParticleConfiguration(
              shape: CircleShape(),
              size: const Size(1, 1),
              color: LinearInterpolationParticleColor(
                colors: [
                  Colors.orange.shade300,
                  Colors.red.shade300,
                ],
              ),
              postEffectBuilder: (particle) => ExplodeEffect(
                  particleConfiguration: ParticleConfiguration(
                    shape: CircleShape(),
                    size: const Size(1, 1),
                    color: LinearInterpolationParticleColor(
                      colors: [
                        Colors.greenAccent.shade100,
                        Colors.yellow.shade300,
                        Colors.orange.shade300,
                        Colors.pinkAccent.shade100,
                        Colors.red.shade300,
                        Colors.purple.shade300,
                        Colors.indigoAccent.shade100,
                        Colors.blue.shade300,
                      ],
                    ),
                  ),
                  effectConfiguration: defaultEffectConfiguration.copyWith(
                    maxAngle: 180,
                    minAngle: -180,
                    particleCount: 20,
                    particlesPerEmit: 2,
                    distanceCurve: Curves.decelerate,
                    origin: particle.position,
                    emitDuration: 10,
                  ))),
          effectConfiguration: defaultEffectConfiguration.copyWith(
            emitDuration: 500,
            distanceCurve: Curves.decelerate,
            origin: Offset(size.width / 2, size.height / 2),
          ),
        )
      ],
    );
  }
}
