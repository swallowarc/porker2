import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/domain.pbenum.dart';
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

const List<Point> _extraPoints = [
  Point.POINT_COFFEE,
  Point.POINT_QUESTION,
];

const double _fanLayoutMinWidth = 750;

class HandCards extends HookConsumerWidget {
  const HandCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final pokerNotifier = ref.read(pokerProvider.notifier);
    final poker = ref.watch(pokerProvider);

    final myPoint = pokerNotifier.myPoint(user.userID);
    final isObserver = pokerNotifier.isObserver(user.userID);

    if (isObserver) {
      return Container();
    }

    HandCard buildCard(Point point, int delayMilliseconds) => HandCard(
          point: point,
          onTap: () {
            if (!pokerNotifier.votable) {
              return;
            }
            pokerNotifier
                .castVote(myPoint == point ? Point.POINT_UNSPECIFIED : point);
          },
          delayMilliseconds: delayMilliseconds,
          selected: myPoint == point,
          displayMode: poker.displayMode,
        );

    return LayoutBuilder(
      builder: (context, constraints) =>
          constraints.maxWidth >= _fanLayoutMinWidth
              ? _fanLayout(buildCard)
              : _scrollLayout(buildCard),
    );
  }

  Widget _fanLayout(HandCard Function(Point, int) buildCard) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 180,
            width: 730,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: List.generate(pointOrder.length, (index) {
                    final indexCenter = pointOrder.length ~/ 2;
                    final angle = (index - indexCenter) * 0.05;
                    final leftOffset = (index - indexCenter) * 70.0;

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
                        child: buildCard(pointOrder[index], index * 100),
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
              buildCard(Point.POINT_COFFEE, 1000),
              const SizedBox(width: 20),
              buildCard(Point.POINT_QUESTION, 1100),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scrollLayout(HandCard Function(Point, int) buildCard) {
    final allPoints = [...pointOrder, ..._extraPoints];

    // BaseCard の SizedBox(width: 100) と揃える。
    const cardWidth = 100.0;
    // 72 未満にすると "0.5" などの中央ラベルが右隣のカードに隠れる。
    const cardStep = 72.0;
    final stripWidth = cardWidth + (allPoints.length - 1) * cardStep;

    return SizedBox(
      height: 180,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: stripWidth,
          height: 180,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (var i = 0; i < allPoints.length; i++)
                Positioned(
                  left: i * cardStep,
                  bottom: 10,
                  child: buildCard(allPoints[i], i * 100),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
