import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pbenum.dart';
import 'package:porker2fe/presentation/widget/poker/base_card.dart';

class FieldCard extends ConsumerStatefulWidget {
  final String loginID;
  late final int _loginIDHash;
  final String loginName;
  late final int _loginNameHash;

  final Point point;
  final UserRole role;
  final bool opened;
  final DisplayMode displayMode;

  FieldCard({
    super.key,
    required this.loginID,
    required this.loginName,
    required this.point,
    required this.role,
    required this.opened,
    this.displayMode = DisplayMode.DISPLAY_MODE_POINT,
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

  Point lastPoint = Point.POINT_UNSPECIFIED;
  double tilt = (Random().nextDouble() - 0.5) * 0.2;

  @override
  void initState() {
    super.initState();

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

    final duration = Random().nextInt(200) + 100;
    _turnController = AnimationController(
      duration: Duration(milliseconds: duration),
      vsync: this,
    );

    if (mounted) {
      _slideController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant FieldCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final voted = widget.point != Point.POINT_UNSPECIFIED;
    final nowVoted = oldWidget.point != widget.point && voted;
    final nowOpened = !oldWidget.opened && widget.opened;

    if (nowOpened) {
      _turnController.reset();
      _slideController.reset();
      _turnController.forward();
    } else if (nowVoted) {
      _turnController.reset();
      _slideController.reset();
      _slideController.forward();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _turnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voted = widget.point != Point.POINT_UNSPECIFIED;
    final isObserver = widget.role == UserRole.USER_ROLE_OBSERVER;
    final opacity = isObserver ? 0.7 : 1.0;

    if (!voted) {
      return Opacity(
        opacity: opacity,
        child: SizedBox(
          width: 100,
          height: 130,
          child: Card(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      );
    }

    if (lastPoint != widget.point) {
      lastPoint = widget.point;
      tilt = (Random().nextDouble() - 0.5) * 0.2;
    }

    final card = BaseCard(
      widget.opened,
      widget.point,
      widget._loginIDHash,
      widget._loginNameHash,
      displayMode: widget.displayMode,
    );

    Widget resultCard;
    if (_turnController.isAnimating || _turnController.value > 0) {
      resultCard = AnimatedBuilder(
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
              transform: Matrix4.rotationZ(tilt),
              child: card,
            ),
          );
        },
      );
    } else {
      resultCard = AnimatedBuilder(
        animation: _slideController,
        builder: (BuildContext context, Widget? child) {
          return SlideTransition(
            position: _slideOffsetAnimation,
            child: Transform(
              transform: Matrix4.rotationZ(tilt),
              child: card,
            ),
          );
        },
      );
    }

    return Opacity(
      opacity: opacity,
      child: resultCard,
    );
  }
}
