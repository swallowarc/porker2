import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pbenum.dart';
import 'package:porker2fe/domain/entity/point.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/poker/base_card.dart';
import 'package:porker2fe/presentation/widget/poker/hand_card.dart';
import 'package:sprintf/sprintf.dart';

const pointListLength = 11;

class FieldCard extends ConsumerStatefulWidget {
  final String loginID;
  late final _loginIDHash;
  final String loginName;
  late final _loginNameHash;

  final int delayMilliseconds;

  FieldCard({
    super.key,
    required this.delayMilliseconds,
    required this.loginID,
    required this.loginName,
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
  late Animation<Offset> _turnOffsetAnimation;

  Point _point = Point.POINT_UNSPECIFIED;
  VoteState _voteState = VoteState.VOTE_STATE_HIDE;

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

    _turnController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _turnOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.5),
    ).animate(CurvedAnimation(
      parent: _turnController,
      curve: Curves.easeInOut,
    ));

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
    final poker = ref.watch(pokerProvider);

    final card = Expanded(
      child: BaseCard(opened, point, loginIDHash, loginNameHash),
    );

    return AnimatedBuilder(
      animation: Listenable.merge([_slideController, _turnController]),
      builder: (BuildContext context, Widget? child) {
        final offset = _slideController.isCompleted
            ? _turnOffsetAnimation
            : _slideOffsetAnimation;
        return SlideTransition(
          position: offset,
          child: card,
        );
      },
    );
  }
}
