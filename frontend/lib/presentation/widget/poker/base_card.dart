import 'package:material_ui/material_ui.dart';
import 'package:porker2fe/domain/point.dart';
import 'package:porker2fe/domain/room.dart';

final Map<Point, Color> _pointColors = {
  Point.coffee: Colors.blueGrey.shade300,
  Point.p0: Colors.grey.shade200,
  Point.p0_5: Colors.lightBlue.shade100,
  Point.p1: Colors.lightBlue.shade200,
  Point.p2: Colors.lightGreenAccent.shade100,
  Point.p3: Colors.lightGreenAccent.shade200,
  Point.p5: Colors.yellowAccent.shade100,
  Point.p8: Colors.orangeAccent.shade100,
  Point.p13: Colors.red.shade200,
  Point.p21: Colors.red.shade400,
  Point.question: Colors.purple.shade100,
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

/// 裏面の絵柄の枚数 (images/card-00000.png 〜)
const _backImageCount = 33;

class BaseCard extends StatelessWidget {
  final bool opened;
  final Point point;

  /// 裏面の色と絵柄をユーザーごとに固定するための種
  final String loginID;
  final String loginName;
  final DisplayMode displayMode;

  const BaseCard(this.opened, this.point, this.loginID, this.loginName,
      {super.key, this.displayMode = DisplayMode.point});

  const BaseCard.initOpen(this.point, {super.key, this.displayMode = DisplayMode.point})
      : opened = true,
        loginID = "",
        loginName = "";

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
              point.display(displayMode),
              style: const TextStyle(color: Colors.black54, fontSize: 32),
            ),
          ),
        ),
      );
    }

    final imageID = (loginName.hashCode % _backImageCount).toString().padLeft(5, '0');
    return SizedBox(
      width: 100,
      height: 130,
      child: Card(
        color: _cardColors[loginID.hashCode % _cardColors.length],
        child: Container(
          margin: const EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image(
              fit: BoxFit.scaleDown,
              image: AssetImage("images/card-$imageID.png"),
            ),
          ),
        ),
      ),
    );
  }
}
