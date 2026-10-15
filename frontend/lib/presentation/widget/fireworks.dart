import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:material_ui/material_ui.dart';

/// 開花の種類
enum _BurstType {
  /// 牡丹: 尾を引かずに球状に広がる
  peony,

  /// 菊: 尾を引きながら球状に広がる
  chrysanthemum,

  /// 柳: 金色の光が長く尾を引いて垂れ下がる
  willow,

  /// 輪: 傾いた円環状に広がる
  ring,
}

/// 打ち上げ玉・星（火の粉）・開花時の閃光を同じ構造で表す粒子
class _Particle {
  _Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.lifespan,
    required this.radius,
    this.drag = 0,
    this.gravityScale = 1,
    this.trailLength = 0,
    this.flicker = false,
    this.crackle = false,
    this.isFlash = false,
    this.rocket,
  });

  Offset position;
  Offset velocity;
  final Color color;
  final double lifespan;
  final double radius;

  /// 空気抵抗（1 秒あたりの速度減衰率の指数）
  final double drag;
  final double gravityScale;
  final int trailLength;

  /// 燃え尽き際に明滅させるか
  final bool flicker;

  /// 燃え尽きたときに小さく弾ける（冠菊のパチパチ）か
  final bool crackle;

  /// 開花の瞬間の閃光か
  final bool isFlash;

  /// 打ち上げ玉の場合、頂点で開く花の情報
  final _Rocket? rocket;

  final List<Offset> trail = [];
  double age = 0;

  double get progress => (age / lifespan).clamp(0, 1);
  bool get isDead => age >= lifespan;
}

class _Rocket {
  const _Rocket({required this.type, required this.colors});

  final _BurstType type;
  final List<Color> colors;
}

/// 花火のシミュレーション。重力・空気抵抗・寿命を持つ粒子をフレームごとに更新する。
class _FireworksSimulation extends ChangeNotifier {
  _FireworksSimulation({required this.additive});

  /// 加算合成で描画するか（暗い背景向け）
  bool additive;

  final _random = Random();
  final List<_Particle> _particles = [];
  Size _size = Size.zero;
  double _untilNextLaunch = 0;

  static const _maxParticles = 1800;

  static const List<List<Color>> _palettes = [
    [Color(0xFFFF5252), Color(0xFFFFAB40)],
    [Color(0xFF40C4FF), Color(0xFFE1F5FE)],
    [Color(0xFF69F0AE), Color(0xFFFFFF00)],
    [Color(0xFFFF4081), Color(0xFFEA80FC)],
    [Color(0xFFB388FF), Color(0xFF64FFDA)],
    [Color(0xFFFFD740), Color(0xFFFF6E40)],
  ];
  static const _gold = Color(0xFFFFC46B);

  List<_Particle> get particles => _particles;

  /// 画面サイズに比例させた基準長。花火の大きさや重力をこれで揃える。
  double get _unit => _size.shortestSide;

  double get _gravity => _unit * 0.32;

  set size(Size value) {
    if (_size == Size.zero && value != Size.zero) {
      // 表示直後に間を置かず打ち上げる
      _untilNextLaunch = 0;
    }
    _size = value;
  }

  void update(double dt) {
    if (_size.isEmpty) return;

    _untilNextLaunch -= dt;
    if (_untilNextLaunch <= 0) {
      final salvo = _random.nextDouble() < 0.25 ? 3 : 1;
      for (var i = 0; i < salvo; i++) {
        _launch();
      }
      _untilNextLaunch = 0.45 + _random.nextDouble() * 0.7;
    }

    final spawned = <_Particle>[];
    for (final p in _particles) {
      p.age += dt;
      if (p.trailLength > 0) {
        p.trail.add(p.position);
        if (p.trail.length > p.trailLength) p.trail.removeAt(0);
      }
      if (p.drag > 0) p.velocity *= exp(-p.drag * dt);
      p.velocity += Offset(0, _gravity * p.gravityScale * dt);
      p.position += p.velocity * dt;

      final rocket = p.rocket;
      if (rocket != null) {
        _emitRocketSparks(p, spawned);
        // 上昇速度がほぼ失われた頂点付近で開花させる
        if (p.velocity.dy > -_unit * 0.08) {
          p.age = p.lifespan;
          _burst(p.position, rocket, spawned);
        }
      } else if (p.crackle && p.isDead) {
        _crackle(p.position, spawned);
      }
    }
    _particles.removeWhere((p) => p.isDead);
    final room = _maxParticles - _particles.length;
    if (room > 0) _particles.addAll(spawned.take(room));

    notifyListeners();
  }

  double _between(double min, double max) =>
      min + _random.nextDouble() * (max - min);

  T _pick<T>(List<T> list) => list[_random.nextInt(list.length)];

  void _launch() {
    final start = Offset(_size.width * _between(0.15, 0.85), _size.height + 4);
    final apexY = _size.height * _between(0.12, 0.42);
    // 空気抵抗なしの鉛直投げ上げで頂点がちょうど apexY になる初速
    final speed = sqrt(2 * _gravity * (start.dy - apexY));
    final type = _pick(_BurstType.values);
    _particles.add(
      _Particle(
        position: start,
        velocity: Offset(_between(-0.06, 0.06) * speed, -speed),
        color: const Color(0xFFFFE0B2),
        lifespan: 10,
        radius: _unit * 0.0035,
        trailLength: 6,
        rocket: _Rocket(
          type: type,
          colors: type == _BurstType.willow ? const [_gold] : _pick(_palettes),
        ),
      ),
    );
  }

  void _emitRocketSparks(_Particle rocket, List<_Particle> out) {
    for (var i = 0; i < 2; i++) {
      out.add(
        _Particle(
          position: rocket.position,
          velocity: Offset(
            _between(-1, 1) * _unit * 0.03,
            _between(0, 1) * _unit * 0.05,
          ),
          color: _gold,
          lifespan: _between(0.2, 0.5),
          radius: _unit * 0.0018,
          drag: 2,
          flicker: true,
        ),
      );
    }
  }

  void _burst(Offset origin, _Rocket rocket, List<_Particle> out) {
    final speed = _unit * _between(0.38, 0.5);

    out.add(
      _Particle(
        position: origin,
        velocity: Offset.zero,
        color: rocket.colors.first,
        lifespan: 0.25,
        radius: _unit * 0.12,
        gravityScale: 0,
        isFlash: true,
      ),
    );

    switch (rocket.type) {
      case _BurstType.peony:
        _sphere(
          out,
          origin,
          rocket.colors.first,
          90,
          speed,
          trailLength: 0,
          lifespan: 1.4,
          drag: 1.6,
        );
        // 芯（内側の別色の層）
        _sphere(
          out,
          origin,
          rocket.colors.last,
          40,
          speed * 0.45,
          trailLength: 0,
          lifespan: 1.2,
          drag: 1.6,
        );
      case _BurstType.chrysanthemum:
        _sphere(
          out,
          origin,
          rocket.colors.first,
          110,
          speed,
          trailLength: 9,
          lifespan: 1.7,
          drag: 1.4,
          crackle: true,
        );
      case _BurstType.willow:
        _sphere(
          out,
          origin,
          rocket.colors.first,
          80,
          speed * 0.85,
          trailLength: 16,
          lifespan: 3.0,
          drag: 2.2,
          gravityScale: 0.55,
          crackle: true,
        );
      case _BurstType.ring:
        _ring(out, origin, rocket.colors, 60, speed);
    }
  }

  /// 球殻上に一様に散った星を正面から見た配置で放つ
  void _sphere(
    List<_Particle> out,
    Offset origin,
    Color color,
    int count,
    double speed, {
    required int trailLength,
    required double lifespan,
    required double drag,
    double gravityScale = 0.35,
    bool crackle = false,
  }) {
    for (var i = 0; i < count; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final z = _between(-1, 1);
      final r = sqrt(1 - z * z) * speed * _between(0.94, 1.06);
      out.add(
        _Particle(
          position: origin,
          velocity: Offset(cos(angle) * r, sin(angle) * r),
          color: color,
          lifespan: lifespan * _between(0.8, 1.1),
          radius: _unit * 0.0032,
          drag: drag,
          gravityScale: gravityScale,
          trailLength: trailLength,
          flicker: true,
          crackle: crackle && _random.nextDouble() < 0.35,
        ),
      );
    }
  }

  /// 斜めから見た輪の形に放つ
  void _ring(
    List<_Particle> out,
    Offset origin,
    List<Color> colors,
    int count,
    double speed,
  ) {
    final tilt = _between(0.25, 0.7);
    final rotation = _between(-0.6, 0.6);
    for (var i = 0; i < count; i++) {
      final angle = 2 * pi * i / count;
      final x = cos(angle) * speed;
      final y = sin(angle) * speed * tilt;
      out.add(
        _Particle(
          position: origin,
          velocity: Offset(
            x * cos(rotation) - y * sin(rotation),
            x * sin(rotation) + y * cos(rotation),
          ),
          color: colors[i.isEven ? 0 : colors.length - 1],
          lifespan: _between(1.3, 1.6),
          radius: _unit * 0.0035,
          drag: 1.5,
          gravityScale: 0.3,
          trailLength: 5,
          flicker: true,
        ),
      );
    }
  }

  void _crackle(Offset origin, List<_Particle> out) {
    for (var i = 0; i < 3; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final s = _unit * _between(0.04, 0.09);
      out.add(
        _Particle(
          position: origin,
          velocity: Offset(cos(angle) * s, sin(angle) * s),
          color: Colors.white,
          lifespan: _between(0.08, 0.2),
          radius: _unit * 0.0022,
          drag: 3,
          gravityScale: 0.2,
        ),
      );
    }
  }
}

class _FireworksPainter extends CustomPainter {
  _FireworksPainter(this.simulation) : super(repaint: simulation);

  final _FireworksSimulation simulation;
  final _random = Random();
  final _paint = Paint();
  final _stroke = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final dark = simulation.additive;
    final blend = dark ? BlendMode.plus : BlendMode.srcOver;
    _paint.blendMode = blend;
    _stroke.blendMode = blend;

    for (final p in simulation.particles) {
      final t = p.progress;

      if (p.isFlash) {
        final a = 1 - t;
        _paint.shader = RadialGradient(
          colors: [
            (dark ? Colors.white : p.color).withValues(alpha: 0.5 * a),
            p.color.withValues(alpha: 0.25 * a),
            p.color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: p.position, radius: p.radius));
        canvas.drawCircle(p.position, p.radius, _paint);
        _paint.shader = null;
        continue;
      }

      // 寿命の後半で暗くなり、燃え尽き際はちらつく
      var alpha = t < 0.55 ? 1.0 : (1 - t) / 0.45;
      if (p.flicker && t > 0.6) alpha *= 0.25 + _random.nextDouble() * 0.75;
      if (alpha <= 0.01) continue;

      // 暗い背景では白に寄せて発光感を出し、明るい背景では沈ませて輪郭を立てる
      final color = dark
          ? Color.lerp(p.color, Colors.white, 0.45)!
          : Color.lerp(p.color, Colors.black, 0.15)!;

      final trail = p.trail;
      for (var i = 1; i < trail.length; i++) {
        final k = i / trail.length;
        _stroke
          ..color = (dark ? p.color : color).withValues(alpha: alpha * k * 0.6)
          ..strokeWidth = p.radius * (0.6 + k);
        canvas.drawLine(
          trail[i - 1],
          i == trail.length - 1 ? p.position : trail[i],
          _stroke,
        );
      }

      if (dark) {
        _paint.color = p.color.withValues(alpha: alpha * 0.12);
        canvas.drawCircle(p.position, p.radius * 2.4, _paint);
      }
      _paint.color = color.withValues(alpha: alpha);
      canvas.drawCircle(p.position, p.radius, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FireworksPainter oldDelegate) =>
      oldDelegate.simulation != simulation;
}

/// 全員の投票が揃ったときに表示する花火。表示している間は打ち上げ続ける。
class FireWorks extends StatefulWidget {
  const FireWorks({super.key});

  @override
  State<FireWorks> createState() => _FireWorksState();
}

class _FireWorksState extends State<FireWorks>
    with SingleTickerProviderStateMixin {
  final _simulation = _FireworksSimulation(additive: false);
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    // タブが非表示から復帰した直後などの大きな飛びで粒子が吹き飛ばないよう上限を設ける
    final dt = min((elapsed - _lastElapsed).inMicroseconds / 1e6, 1 / 20);
    _lastElapsed = elapsed;
    _simulation.update(dt);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _simulation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _simulation.additive = Theme.of(context).brightness == Brightness.dark;
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          _simulation.size = constraints.biggest;
          return CustomPaint(
            size: Size.infinite,
            painter: _FireworksPainter(_simulation),
          );
        },
      ),
    );
  }
}
