import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/presentation/invoke.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/dialog.dart';
import 'package:porker2fe/presentation/widget/rainbow_text.dart';

class Porker2AppBar extends HookConsumerWidget implements PreferredSizeWidget {
  final String title;

  const Porker2AppBar({super.key, required this.title}) : super();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final poker = ref.watch(pokerProvider);
    final actions = <Widget>[];

    if (poker.inRoom) {
      actions.add(
        Tooltip(
          message: 'Leave Room',
          child: IconButton(
            icon: const Icon(Icons.door_back_door_outlined),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) => TwoChoiceDialog(
                  title: 'Leave Room',
                  message: 'Do you want to leave this poker?',
                  onYes: () => invoke(context, () => poker.leaveRoom(),
                      () => GoRouter.of(context).pop()),
                  onNo: () {},
                ),
              );
            },
          ),
        ),
      );
    }

    if (user.alreadyLogin) {
      actions.add(
        Tooltip(
          message: 'Logout',
          child: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              showDialog<void>(
                context: context,
                builder: (_) => TwoChoiceDialog(
                  title: 'Logout',
                  message: 'Do you want to log out?',
                  onYes: () => invoke(context, () => user.logout(),
                      () => GoRouter.of(context).go('/')),
                  onNo: () {},
                ),
              );
            },
          ),
        ),
      );
    }

    return AppBar(
      title: RainbowText(
        text: title,
        style: const TextStyle(
          fontSize: 30,
        ),
      ),
      actions: actions,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
