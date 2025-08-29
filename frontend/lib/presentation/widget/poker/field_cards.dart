import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/presentation/invoke.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/dialog.dart';
import 'package:porker2fe/presentation/widget/poker/field_card.dart';

class FieldCards extends HookConsumerWidget {
  const FieldCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poker = ref.watch(pokerProvider);
    final user = ref.watch(userProvider);
    final bool isAdmin = poker.adminUserID == user.userID;

    final List<Widget> cards = poker.ballots
        .map(
          (e) => Column(
            children: [
              FieldCard(
                point: e.point,
                loginID: e.userId,
                loginName: e.userName,
                opened: ref.read(pokerProvider.notifier).opened,
                displayMode: poker.displayMode,
              ),
              const SizedBox(height: 4),
              _nameLabel(
                context,
                e.userName,
                e.userId,
                poker.adminUserID,
                isAdmin,
                () {
                  showDialog<void>(
                    context: context,
                    builder: (_) => TwoChoiceDialog(
                      title: 'Forced exit',
                      message: 'Do you want to force this user to leave the room?',
                      onYes: () => invoke(
                        context,
                        () => ref.read(pokerProvider.notifier).kickUser(e.userId),
                        (_) {},
                      ),
                    ),
                  );
                },
              ),
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

  Widget _nameLabel(
    BuildContext context,
    String userName,
    String userID,
    String adminUserID,
    bool isAdmin,
    Function closeFn,
  ) {
    List<Widget> children = [];

    if (userID == adminUserID) {
      children.add(
        Tooltip(
          message: "Room admin",
          child: Icon(
            Icons.star,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
      );

      children.add(const SizedBox(width: 5));
    } else if (isAdmin) {
      children.add(
        Tooltip(
          message: "Forced exit",
          child: GestureDetector(
            onTap: () => closeFn(),
            child: Icon(
              Icons.cancel_outlined,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
        ),
      );

      children.add(const SizedBox(width: 5));
    }

    children.add(Text(userName));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
