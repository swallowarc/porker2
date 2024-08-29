import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/poker/field_card.dart';

class FieldCards extends HookConsumerWidget {
  const FieldCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poker = ref.watch(pokerProvider);

    final List<Widget> cards = poker.ballots
        .map(
          (e) => Column(
            children: [
              FieldCard(
                point: e.point,
                loginID: e.userId,
                loginName: e.userName,
                opened: ref.read(pokerProvider.notifier).opened,
              ),
              const SizedBox(height: 4),
              e.userId == poker.adminUserID
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: "Room admin",
                          child: Icon(
                            Icons.star,
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(e.userName),
                      ],
                    )
                  : Text(e.userName),
            ],
          ),
        )
        .toList();

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 30),
      child: Wrap(
        spacing: 20, // カード同士の間隔を設定
        runSpacing: 30, // 複数行に渡る場合の行間
        alignment: WrapAlignment.center,
        children: cards,
      ),
    );
  }
}
