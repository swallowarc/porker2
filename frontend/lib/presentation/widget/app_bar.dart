import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/presentation/const.dart';
import 'package:porker2fe/presentation/invoke.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/rainbow_text.dart';

class Porker2AppBar extends HookConsumerWidget implements PreferredSizeWidget {
  const Porker2AppBar({super.key}) : super();

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
              poker.leaveRoom();
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
            onPressed: () {
              invoke(context, () async {
                user.logout();
              }, () => GoRouter.of(context).pop());
            },
          ),
        ),
      );
    }

    return AppBar(
      title: _Title(),
      actions: actions,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const RainbowText(
      text: appBarTitle,
      style: TextStyle(
        fontSize: 30,
      ),
    );
  }
}
