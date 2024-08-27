import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pbenum.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/poker/hand_card.dart';

const List<Point> pointOrder = [
  Point.POINT_0,
  Point.POINT_0_5,
  Point.POINT_1,
  Point.POINT_2,
  Point.POINT_3,
  Point.POINT_5,
  Point.POINT_8,
  Point.POINT_13,
  Point.POINT_21,
];

const _pointListLength = 9;

class HandCards extends HookConsumerWidget {
  const HandCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final pokerNotifier = ref.read(pokerProvider.notifier);
    final _ = ref.watch(pokerProvider);

    final myPoint = pokerNotifier.myPoint(user.userID);

    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 180,
            width: 730,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: List.generate(_pointListLength, (index) {
                    const indexCenter = _pointListLength ~/ 2;
                    final angle = (index - indexCenter) * 0.05;
                    final leftOffset = (index - indexCenter) * 78.0;

                    double topOffset = 8;
                    switch (index) {
                      case 3:
                      case 5:
                        topOffset = 10;
                        break;
                      case 2:
                      case 6:
                        topOffset = 18;
                        break;
                      case 1:
                      case 7:
                        topOffset = 30;
                        break;
                      case 0:
                      case 8:
                        topOffset = 46;
                        break;
                    }

                    return Positioned(
                      left: constraints.maxWidth / 2 + leftOffset - 50,
                      top: topOffset,
                      child: Transform.rotate(
                        angle: angle,
                        child: HandCard(
                          point: pointOrder[index],
                          onTap: () {
                            final notifier = ref.read(pokerProvider.notifier);
                            if (notifier.votable) {
                              notifier.castVote(pointOrder[index]);
                            }
                          },
                          delayMilliseconds: index * 100,
                          selected: myPoint == pointOrder[index],
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HandCard(
                point: Point.POINT_COFFEE,
                onTap: () {
                  if (pokerNotifier.votable) {
                    pokerNotifier.castVote(Point.POINT_COFFEE);
                  }
                },
                delayMilliseconds: 1000,
                selected: myPoint == Point.POINT_COFFEE,
              ),
              const SizedBox(width: 20),
              HandCard(
                point: Point.POINT_QUESTION,
                onTap: () {
                  if (pokerNotifier.votable) {
                    pokerNotifier.castVote(Point.POINT_QUESTION);
                  }
                },
                delayMilliseconds: 1100,
                selected: myPoint == Point.POINT_QUESTION,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
