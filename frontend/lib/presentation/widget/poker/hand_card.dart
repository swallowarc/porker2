import 'package:flutter/material.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/domain/entity/point.dart';

const List<Point> pointOrder = [
  Point.POINT_COFFEE,
  Point.POINT_0,
  Point.POINT_0_5,
  Point.POINT_1,
  Point.POINT_2,
  Point.POINT_3,
  Point.POINT_5,
  Point.POINT_8,
  Point.POINT_13,
  Point.POINT_21,
  Point.POINT_QUESTION,
];

const pointListLength = 11;

final Map<Point, Color> pointColors = {
  Point.POINT_COFFEE: Colors.teal.shade100,
  Point.POINT_0: Colors.grey.shade200,
  Point.POINT_0_5: Colors.lightBlue.shade100,
  Point.POINT_1: Colors.lightBlue.shade200,
  Point.POINT_2: Colors.lightGreenAccent.shade100,
  Point.POINT_3: Colors.lightGreenAccent.shade200,
  Point.POINT_5: Colors.yellowAccent.shade100,
  Point.POINT_8: Colors.orangeAccent.shade100,
  Point.POINT_13: Colors.red.shade200,
  Point.POINT_21: Colors.red.shade400,
  Point.POINT_QUESTION: Colors.purple.shade100,
};

class HandCard extends StatefulWidget {
  final Point point;
  final Function() onTap;
  final int delayMilliseconds;

  const HandCard(
      {super.key,
      required this.point,
      required this.onTap,
      required this.delayMilliseconds});

  @override
  HandCardState createState() => HandCardState();
}

class HandCardState extends State<HandCard> with TickerProviderStateMixin {
  late AnimationController _initialController;
  late Animation<Offset> _initialOffsetAnimation;

  late AnimationController _tapController;
  late Animation<Offset> _tapOffsetAnimation;

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

    _tapController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _tapOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.5),
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
      if (_tapController.isCompleted) {
        _tapController.reverse();
      } else {
        _tapController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = GestureDetector(
      onTap: _handleTap,
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
      animation: Listenable.merge([_initialController, _tapController]),
      builder: (BuildContext context, Widget? child) {
        final offset = _initialController.isCompleted
            ? _tapOffsetAnimation
            : _initialOffsetAnimation;
        return SlideTransition(
          position: offset,
          child: card,
        );
      },
    );
  }
}
