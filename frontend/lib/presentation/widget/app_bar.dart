import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/presentation/const.dart';
import 'package:porker2fe/presentation/invoke.dart';
import 'package:porker2fe/presentation/router/router.dart';
import 'package:porker2fe/application/provider.dart';
import 'package:porker2fe/presentation/widget/dialog.dart';
import 'package:porker2fe/presentation/widget/rainbow_text.dart';

class Porker2AppBar extends HookConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool enableDrawer;
  final bool enableLogout;
  final bool enableCopyRoomURL;
  final VoidCallback? onLeave;

  const Porker2AppBar({
    super.key,
    required this.title,
    required this.enableDrawer,
    required this.enableLogout,
    required this.enableCopyRoomURL,
    this.onLeave,
  }) : super();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = <Widget>[];

    final bool isMediumScreen =
        MediaQuery.sizeOf(context).width < mediumScreenBoundary;

    if (onLeave != null) {
      final errorColor = Theme.of(context).colorScheme.error;
      actions.add(
        isMediumScreen
            ? IconButton(
                onPressed: onLeave,
                icon: Icon(Icons.exit_to_app, color: errorColor),
                tooltip: 'Leave room',
              )
            : Padding(
                padding: const EdgeInsets.only(right: 4),
                child: TextButton.icon(
                  onPressed: onLeave,
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text('Leave'),
                  style: TextButton.styleFrom(foregroundColor: errorColor),
                ),
              ),
      );
    }

    if (enableLogout) {
      final user = ref.read(userProvider.notifier);
      final userName = ref.watch(userProvider).userName;
      actions.add(
        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle),
          tooltip: 'Account',
          onSelected: (value) {
            if (value != 'logout') {
              return;
            }
            // ログアウトするとサーバーが部屋から外すため購読が終わり、この画面が
            // 先に破棄されることがある。context に依存せず router で確実にログイン画面
            // (room-id なし) へ戻す。さもないと redirect の再評価で /?room-id=X に残り、
            // 次にログインした人がその部屋へ入ってしまう
            final router = ref.read(routerProvider);
            showDialog<void>(
              context: context,
              builder: (_) => TwoChoiceDialog(
                title: 'Logout',
                message: 'Do you want to log out?',
                onYes: () => invoke(context, () async {
                  await user.logout();
                  router.go(LoginRoute().location);
                }, (_) {}),
              ),
            );
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              enabled: false,
              child: Text(userName),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      );
    }

    final txt = RainbowText(
      text: title,
      style: const TextStyle(
        fontSize: 30,
      ),
    );

    final Widget titleContent = enableCopyRoomURL
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
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: txt,
              ),
            ),
          )
        : txt;

    return AppBar(
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: titleContent,
      ),
      centerTitle: true,
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
