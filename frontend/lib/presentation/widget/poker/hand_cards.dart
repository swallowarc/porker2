import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/application/provider.dart';
import 'package:porker2fe/domain/point.dart';
import 'package:porker2fe/presentation/invoke.dart';
import 'package:porker2fe/presentation/widget/poker/hand_card.dart';

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
      return const SizedBox.shrink();
    }

    HandCard buildCard(Point point, int delayMilliseconds) => HandCard(
          point: point,
          onTap: () {
            if (!pokerNotifier.votable) {
              return;
            }
            invoke(
              context,
              () => pokerNotifier
                  .castVote(myPoint == point ? Point.unspecified : point),
              (_) {},
            );
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
                  children: List.generate(Point.numeric.length, (index) {
                    final indexCenter = Point.numeric.length ~/ 2;
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
                        child: buildCard(Point.numeric[index], index * 100),
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
              for (final (i, p) in Point.extras.indexed) ...[
                if (i > 0) const SizedBox(width: 20),
                buildCard(p, 1000 + i * 100),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _scrollLayout(HandCard Function(Point, int) buildCard) {
    final allPoints = [...Point.numeric, ...Point.extras];

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
