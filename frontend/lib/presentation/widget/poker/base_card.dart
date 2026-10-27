import 'package:material_ui/material_ui.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/domain.pbenum.dart';
import 'package:porker2fe/domain/point.dart';

final Map<Point, Color> _pointColors = {
  Point.POINT_COFFEE: Colors.blueGrey.shade300,
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
      {super.key, this.displayMode = DisplayMode.DISPLAY_MODE_POINT});

  const BaseCard.initOpen(this.point, {super.key, this.displayMode = DisplayMode.DISPLAY_MODE_POINT})
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
              pointFromPbDisplay(point, displayMode),
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
