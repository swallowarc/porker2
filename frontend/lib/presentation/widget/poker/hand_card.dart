import 'package:flutter/material.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/presentation/widget/poker/base_card.dart';

class HandCard extends StatefulWidget {
  final Point point;
  final Function() onTap;
  final int delayMilliseconds;
  final selected;

  const HandCard({
    super.key,
    required this.point,
    required this.onTap,
    required this.delayMilliseconds,
    required this.selected,
  });

  @override
  HandCardState createState() => HandCardState();
}

class HandCardState extends State<HandCard> with TickerProviderStateMixin {
  late AnimationController _initialController;
  late Animation<Offset> _initialOffsetAnimation;

  late AnimationController _tapController;
  late Animation<Offset> _tapOffsetAnimation;

  late bool selected;

  @override
  void initState() {
    super.initState();

    selected = widget.selected;

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

    _tapController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _tapOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.2),
    ).animate(CurvedAnimation(
      parent: _tapController,
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
    _tapController.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();

    setState(() {
      if (selected == widget.selected) {
        return;
      }

      final isSelect = !selected && widget.selected;
      if (isSelect) {
        _initialController.forward();
      }

      final isUnselect = selected && !widget.selected;
      if (isUnselect) {
        _initialController.reverse();
      }

      selected = widget.selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_initialController, _tapController]),
      builder: (BuildContext context, Widget? child) {
        final offset = _initialController.isCompleted
            ? _tapOffsetAnimation
            : _initialOffsetAnimation;
        return SlideTransition(
          position: offset,
          child: GestureDetector(
            onTap: _handleTap,
            child: BaseCard.Opened(widget.point),
          ),
        );
      },
    );
  }
}