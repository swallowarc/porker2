import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/presentation/const.dart';
import 'package:porker2fe/presentation/invoke.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/dialog.dart';
import 'package:porker2fe/presentation/widget/rainbow_text.dart';

class Porker2AppBar extends HookConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool enableDrawer;
  final bool enableLogout;
  final bool enableCopyRoomURL;

  const Porker2AppBar({
    super.key,
    required this.title,
    required this.enableDrawer,
    required this.enableLogout,
    required this.enableCopyRoomURL,
  }) : super();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider.notifier);
    final actions = <Widget>[];

    final bool isMediumScreen =
        MediaQuery.of(context).size.width < mediumScreenBoundary;

    if (enableLogout) {
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
                      (_) => GoRouter.of(context).go('/')),
                ),
              );
            },
          ),
        ),
      );
    }

    final txt = RainbowText(
      text: title,
      style: const TextStyle(
        fontSize: 30,
      ),
    );

    return AppBar(
      title: enableCopyRoomURL
          ? Tooltip(
              message: "Copy room URL",
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    final currentUrl = Uri.base.toString();
                    Clipboard.setData(ClipboardData(text: currentUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('URL copied to clipboard!'),
                        backgroundColor: Colors.lightGreenAccent,
                      ),
                    );
                  },
                  child: txt,
                ),
              ),
            )
          : txt,
      actions: actions,
      automaticallyImplyLeading: false,
      leading: enableDrawer && isMediumScreen
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Drawerを開く
              },
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
