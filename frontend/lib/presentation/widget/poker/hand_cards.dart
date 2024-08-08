import 'package:flutter/material.dart';
import 'package:porker2fe/presentation/widget/poker/poker_card.dart';

class HandCards extends StatelessWidget {
  const HandCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 220,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: List.generate(pointList.length, (index) {
                const indexCenter = pointListLength ~/ 2;
                const indexLast = pointListLength - 1;

                final angle = (index - indexCenter) * 0.05;

                double leftOffset = (index - indexCenter) * 83.0;
                switch (index) {
                  case 0:
                  case indexLast:
                    leftOffset = (index - indexCenter) * 90.0;
                    break;
                }

                double topOffset = 8;
                switch (index) {
                  case 4:
                  case 6:
                    topOffset = 10;
                    break;
                  case 3:
                  case 7:
                    topOffset = 18;
                    break;
                  case 2:
                  case 8:
                    topOffset = 30;
                    break;
                  case 1:
                  case 9:
                    topOffset = 46;
                    break;
                  case 0:
                  case 10:
                    topOffset = 75;
                    break;
                }

                return Positioned(
                  left: constraints.maxWidth / 2 + leftOffset - 50,
                  top: topOffset,
                  child: Transform.rotate(
                    angle: angle,
                    child: HandCard(
                      point: pointList[index],
                      onTap: () {
                        print('Card ${pointList[index].toString()} tapped');
                      },
                      delayMilliseconds: index * 100,
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
