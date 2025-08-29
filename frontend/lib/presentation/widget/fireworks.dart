import 'dart:math';

import 'package:flutter/material.dart';
import 'package:newton_particles/newton_particles.dart';

/// 花火の設定を保持するクラス
class FireworkConfig {
  final Size particleSize;
  final List<Color> colors;
  final double minDistance;
  final double maxDistance;
  final Duration minLifespan;
  final Duration maxLifespan;
  final double minFadeOut;
  final double maxFadeOut;
  final double minBeginScale;
  final double maxBeginScale;
  final double minEndScale;
  final double maxEndScale;
  final int particleCount;
  final double trailWidth;
  final double trailProgress;
  final Duration delay;
  final Curve distanceCurve;
  final double xMin;
  final double xRange;
  final double yMin;
  final double yRange;

  const FireworkConfig({
    required this.particleSize,
    required this.colors,
    this.minDistance = 100,
    this.maxDistance = 200,
    this.minLifespan = const Duration(milliseconds: 800),
    this.maxLifespan = const Duration(milliseconds: 1500),
    this.minFadeOut = 0.15,
    this.maxFadeOut = 0.30,
    this.minBeginScale = 1.0,
    this.maxBeginScale = 1.5,
    this.minEndScale = 0.0,
    this.maxEndScale = 0.5,
    this.particleCount = 30,
    this.trailWidth = 1.5,
    this.trailProgress = 0.25,
    this.delay = Duration.zero,
    this.distanceCurve = Curves.decelerate,
    this.xMin = 0.2,
    this.xRange = 0.6,
    this.yMin = 0.2,
    this.yRange = 0.5,
  });
}

class FireWorks extends StatefulWidget {
  const FireWorks({super.key});

  @override
  State<FireWorks> createState() => _FireWorksState();
}

class _FireWorksState extends State<FireWorks> {
  final _newtonKey = GlobalKey<NewtonState>();
  final _random = Random();

  // 花火の設定リスト
  static const List<FireworkConfig> _fireworkConfigs = [
    // 大きな花火1（オレンジ・赤系）
    FireworkConfig(
      particleSize: Size(3, 3),
      colors: [Colors.orange, Colors.red, Colors.yellow],
      minDistance: 200,
      maxDistance: 400,
      minLifespan: Duration(milliseconds: 1200),
      maxLifespan: Duration(milliseconds: 2100),
      particleCount: 40,
      trailWidth: 2,
      trailProgress: 0.3,
      delay: Duration.zero,
    ),
    // 大きな花火2（カラフル）
    FireworkConfig(
      particleSize: Size(2, 2),
      colors: [
        Colors.greenAccent,
        Colors.yellow,
        Colors.orange,
        Colors.pinkAccent,
        Colors.red,
        Colors.purple,
        Colors.indigoAccent,
        Colors.blue,
      ],
      minDistance: 150,
      maxDistance: 350,
      minLifespan: Duration(milliseconds: 800),
      maxLifespan: Duration(milliseconds: 1500),
      minFadeOut: 0.2,
      maxFadeOut: 0.4,
      minBeginScale: 0.8,
      maxBeginScale: 1.2,
      minEndScale: 0,
      maxEndScale: 0.3,
      particleCount: 50,
      trailWidth: 1,
      trailProgress: 0.2,
      delay: Duration(milliseconds: 200),
      distanceCurve: Curves.easeOutCubic,
    ),
    // 中サイズ花火1（青系）
    FireworkConfig(
      particleSize: Size(2.5, 2.5),
      colors: [Colors.cyan, Colors.lightBlue, Colors.indigo],
      minDistance: 100,
      maxDistance: 250,
      minLifespan: Duration(milliseconds: 1000),
      maxLifespan: Duration(milliseconds: 1800),
      minBeginScale: 1.0,
      maxBeginScale: 1.3,
      minEndScale: 0,
      maxEndScale: 0.4,
      particleCount: 30,
      delay: Duration(milliseconds: 500),
    ),
    // 中サイズ花火2（緑系）
    FireworkConfig(
      particleSize: Size(2.5, 2.5),
      colors: [Colors.lime, Colors.green, Colors.teal],
      minDistance: 100,
      maxDistance: 250,
      minLifespan: Duration(milliseconds: 1000),
      maxLifespan: Duration(milliseconds: 1800),
      minBeginScale: 1.0,
      maxBeginScale: 1.3,
      minEndScale: 0,
      maxEndScale: 0.4,
      particleCount: 30,
      delay: Duration(milliseconds: 700),
    ),
  ];

  // 小さな花火の設定
  static const FireworkConfig _smallFireworkConfig = FireworkConfig(
    particleSize: Size(1.5, 1.5),
    colors: [Colors.pink, Colors.amber, Colors.lightGreen],
    minDistance: 80,
    maxDistance: 180,
    minLifespan: Duration(milliseconds: 600),
    maxLifespan: Duration(milliseconds: 1200),
    minFadeOut: 0.2,
    maxFadeOut: 0.4,
    minBeginScale: 0.8,
    maxBeginScale: 1.0,
    minEndScale: 0,
    maxEndScale: 0.2,
    particleCount: 20,
    trailWidth: 1,
    trailProgress: 0.2,
    distanceCurve: Curves.easeOut,
    yMin: 0.3,  // 下寄り
    yRange: 0.5,
  );

  @override
  void initState() {
    super.initState();
    // ウィジェットが作成されたらすぐに花火エフェクトを開始
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startFireworks();
    });
  }

  void _startFireworks() {
    // メインの花火を追加
    for (final config in _fireworkConfigs) {
      if (config.delay == Duration.zero) {
        _addFirework(config);
      } else {
        Future.delayed(config.delay, () {
          if (mounted) {
            _addFirework(config);
          }
        });
      }
    }

    // 小さな花火を連続で追加
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: 1000 + i * 300), () {
        if (mounted) {
          _addFirework(_smallFireworkConfig);
        }
      });
    }

    // 全ての花火が終了した後、再度花火を開始（ループ）
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        _startFireworks();
      }
    });
  }

  /// 花火エフェクトを追加する共通メソッド
  void _addFirework(FireworkConfig config) {
    // 色のバリエーションを作成（shade付きの色を適用）
    final colors = config.colors.map((color) {
      if (color == Colors.orange) return Colors.orange.shade300;
      if (color == Colors.red) return Colors.red.shade300;
      if (color == Colors.yellow) return Colors.yellow.shade400;
      if (color == Colors.greenAccent) return Colors.greenAccent.shade100;
      if (color == Colors.pinkAccent) return Colors.pinkAccent.shade100;
      if (color == Colors.indigoAccent) return Colors.indigoAccent.shade100;
      if (color == Colors.cyan) return Colors.cyan.shade300;
      if (color == Colors.lightBlue) return Colors.lightBlue.shade300;
      if (color == Colors.indigo) return Colors.indigo.shade300;
      if (color == Colors.lime) return Colors.lime.shade300;
      if (color == Colors.green) return Colors.green.shade300;
      if (color == Colors.teal) return Colors.teal.shade300;
      if (color == Colors.pink) return Colors.pink.shade200;
      if (color == Colors.amber) return Colors.amber.shade300;
      if (color == Colors.lightGreen) return Colors.lightGreen.shade300;
      if (color == Colors.blue) return Colors.blue.shade300;
      if (color == Colors.purple) return Colors.purple.shade300;
      return color.withValues(alpha: 0.8);
    }).toList();

    _newtonKey.currentState?.addEffect(
      DeterministicEffectConfiguration(
        particleConfiguration: ParticleConfiguration(
          shape: CircleShape(),
          size: config.particleSize,
          color: LinearInterpolationParticleColor(colors: colors),
        ),
        minAngle: -180,
        maxAngle: 180,
        minDistance: config.minDistance,
        maxDistance: config.maxDistance,
        minParticleLifespan: config.minLifespan,
        maxParticleLifespan: config.maxLifespan,
        minFadeOutThreshold: config.minFadeOut,
        maxFadeOutThreshold: config.maxFadeOut,
        minBeginScale: config.minBeginScale,
        maxBeginScale: config.maxBeginScale,
        minEndScale: config.minEndScale,
        maxEndScale: config.maxEndScale,
        distanceCurve: config.distanceCurve,
        origin: Offset(
          config.xMin + _random.nextDouble() * config.xRange,
          config.yMin + _random.nextDouble() * config.yRange,
        ),
        emitDuration: const Duration(milliseconds: 100),
        particleCount: config.particleCount,
        particlesPerEmit: config.particleCount,
        trail: StraightTrail(
          trailWidth: config.trailWidth,
          trailProgress: config.trailProgress,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Newton(
      key: _newtonKey,
      // 子要素は透明なコンテナで、エフェクトのみを表示
      child: Container(),
    );
  }
}