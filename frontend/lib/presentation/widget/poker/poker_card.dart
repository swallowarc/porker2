import 'package:flutter/material.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/domain/entity/point.dart';

const List<Point> pointList = [
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

final Map<Point, Color> _displayColors = {
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

class PokerCard extends StatefulWidget {
  final Point point;

  const PokerCard({super.key, required this.point});

  @override
  PokerCardState createState() => PokerCardState();
}

class PokerCardState extends State<PokerCard>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Card ${widget.point.toString()} tapped');
      },
      child: SizedBox(
        width: 100,
        height: 130,
        child: Card(
          color: _displayColors[widget.point],
          child: Center(
            child: Text(
              pointFromPb(widget.point),
              style: const TextStyle(color: Colors.black54, fontSize: 40),
            ),
          ),
        ),
      ),
    );
  }
}
