import 'package:flutter/material.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pbenum.dart';
import 'package:porker2fe/domain/entity/point.dart';
import 'package:sprintf/sprintf.dart';

final Map<Point, Color> _pointColors = {
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

final List<Color> _cardColors = [
  Colors.red.shade300,
  Colors.green.shade300,
  Colors.blue.shade300,
  Colors.yellow.shade300,
  Colors.orange.shade300,
  Colors.purple.shade300,
  Colors.white70,
  Colors.indigoAccent.shade100,
  Colors.pinkAccent.shade100,
];

class BaseCard extends StatelessWidget {
  final bool opened;
  final Point point;
  final int loginIDHash;
  final int loginNameHash;

  const BaseCard(this.opened, this.point, this.loginIDHash, this.loginNameHash);

  const BaseCard.Opened(this.point)
      : opened = true,
        loginIDHash = 0,
        loginNameHash = 0;

  @override
  Widget build(BuildContext context) {
    if (opened) {
      return SizedBox(
        width: 100,
        height: 130,
        child: Card(
          color: _pointColors[point],
          child: Center(
            child: Text(
              pointFromPb(point),
              style: const TextStyle(color: Colors.black54, fontSize: 40),
            ),
          ),
        ),
      );
    }

    final int imageID = loginIDHash % 33; // num of latest image no + 1.
    return SizedBox(
      width: 100,
      height: 130,
      child: Card(
        color: _cardColors[loginNameHash % _cardColors.length],
        child: Container(
          child: ClipRRect(
            child: Image(
              fit: BoxFit.scaleDown,
              image: AssetImage(sprintf("images/card-%05d.png", [imageID])),
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: EdgeInsets.all(4.0),
        ),
      ),
    );
  }
}
