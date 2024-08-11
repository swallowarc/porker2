import 'package:flutter/material.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/domain/entity/point.dart';
import 'package:porker2fe/presentation/widget/poker/hand_card.dart';

const pointListLength = 11;

class FieldCard extends StatefulWidget {
  final Point point;
  final Function() onTap;
  final int delayMilliseconds;

  const FieldCard(
      {super.key,
      required this.point,
      required this.onTap,
      required this.delayMilliseconds});

  @override
  FieldCardState createState() => FieldCardState();
}

class FieldCardState extends State<FieldCard> with TickerProviderStateMixin {
  late AnimationController _initialController;
  late Animation<Offset> _initialOffsetAnimation;

  late AnimationController _turnController;
  late Animation<Offset> _turnOffsetAnimation;

  @override
  void initState() {
    super.initState();

    _initialController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _initialOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 10),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _initialController,
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
        _initialController.forward();
      }
    });
  }

  @override
  void dispose() {
    _initialController.dispose();
    _turnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = GestureDetector(
      child: SizedBox(
        width: 100,
        height: 130,
        child: Card(
          color: pointColors[widget.point],
          child: Center(
            child: Text(
              pointFromPb(widget.point),
              style: const TextStyle(color: Colors.black54, fontSize: 40),
            ),
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: Listenable.merge([_initialController, _turnController]),
      builder: (BuildContext context, Widget? child) {
        final offset = _initialController.isCompleted
            ? _turnOffsetAnimation
            : _initialOffsetAnimation;
        return SlideTransition(
          position: offset,
          child: card,
        );
      },
    );
  }
}
