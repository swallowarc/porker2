import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pbenum.dart';
import 'package:porker2fe/presentation/widget/poker/base_card.dart';

class FieldCard extends ConsumerStatefulWidget {
  final String loginID;
  late final _loginIDHash;
  final String loginName;
  late final _loginNameHash;

  final int delayMilliseconds;

  final Point point;
  final bool opened;

  FieldCard({
    super.key,
    required this.delayMilliseconds,
    required this.loginID,
    required this.loginName,
    required this.point,
    required this.opened,
  }) {
    _loginIDHash = loginID.hashCode;
    _loginNameHash = loginName.hashCode;
  }

  @override
  FieldCardState createState() => FieldCardState();
}

class FieldCardState extends ConsumerState<FieldCard>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideOffsetAnimation;

  late AnimationController _turnController;

  Point _point = Point.POINT_UNSPECIFIED;
  bool _opened = false;
  double _tilt = 0.1;

  @override
  void initState() {
    super.initState();

    _point = widget.point;
    _opened = widget.opened;

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _slideOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 10),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _turnController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    Future.delayed(Duration(milliseconds: widget.delayMilliseconds), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _turnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // check if voted, nowVoted, nowOpened
    final voted = widget.point != Point.POINT_UNSPECIFIED;
    final nowVoted = _point == Point.POINT_UNSPECIFIED && voted;
    final nowOpened = !_opened && widget.opened;

    // update point and opened
    _point = widget.point;
    _opened = widget.opened;

    // カードなしパターン (アニメーションなし
    if (!voted) {
      return SizedBox(
        width: 100,
        height: 130,
        child: Card(
          color: Colors.black.withOpacity(0.0),
        ),
      );
    }

    final card = BaseCard(
      widget.opened,
      widget.point,
      widget._loginIDHash,
      widget._loginNameHash,
    );

    // 開票
    if (nowOpened) {
      _turnController.forward();
      return AnimatedBuilder(
        animation: _turnController,
        builder: (context, child) {
          final angle = _turnController.value * pi;
          final transform = Matrix4.rotationY(angle);
          if (angle >= pi / 2) {
            transform.rotateY(pi);
          }
          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Transform(
              transform: Matrix4.rotationZ(_tilt),
              child: card,
            ),
          );
        },
      );
    }

    // 投票
    if (nowVoted) {
      final random = Random();
      _tilt = (random.nextDouble() - 0.5) * 0.2;
      _slideController.forward();
    }

    return AnimatedBuilder(
      animation: _slideController,
      builder: (BuildContext context, Widget? child) {
        return SlideTransition(
          position: _slideOffsetAnimation,
          child: Transform(
            transform: Matrix4.rotationZ(_tilt),
            child: card,
          ),
        );
      },
    );
  }
}
