import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/presentation/const.dart';
import 'package:porker2fe/presentation/invoke.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/app_bar.dart';
import 'package:porker2fe/presentation/widget/dialog.dart';
import 'package:porker2fe/presentation/widget/poker/field_cards.dart';
import 'package:porker2fe/presentation/widget/poker/hand_cards.dart';
import 'package:porker2fe/presentation/widget/poker/vote_buttons.dart';

class PokerPage extends HookConsumerWidget {
  const PokerPage(this.roomId, {super.key});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      final user = ref.read(userProvider.notifier);
      if (!user.alreadyLogin) {
        GoRouter.of(context).go('/?room-id=$roomId');
        return null;
      }

      final poker = ref.read(pokerProvider.notifier);
      poker.joinRoom(roomId);

      return null; // クリーンアップが不要な場合はnullを返す
    }, []); // 空の依存配列を渡すことで、初回のみ実行

    final poker = ref.watch(pokerProvider);
    if (poker.roomID.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool isMediumScreen =
        MediaQuery.of(context).size.width < mediumScreenBoundary;

    const body = Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            FieldCards(),
            VoteButtons(),
            SizedBox(height: 30),
            HandCards(),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: Porker2AppBar(
        title: 'Room ID: ${poker.roomID}',
        enableDrawer: true,
        enableLogout: true,
      ),
      body: Row(
        children: [
          isMediumScreen ? Container() : _Drawer(),
          const Expanded(child: body),
        ],
      ),
      drawer: isMediumScreen ? _Drawer() : null,
    );
  }
}

class _Drawer extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poker = ref.read(pokerProvider.notifier);
    return Drawer(
      width: 200,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 60, // ヘッダーの高さを指定
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.all(16),
              child: Text('Control'),
            ),
          ),
          SwitchListTile(
            title: const Text('Auto open'),
            value: true, // 初期値を設定
            onChanged: (bool value) {
              // スイッチの状態が変更されたときに呼ばれる
            },
          ),
          ListTile(
            title: const Text('Leave room'),
            leading: const Icon(Icons.door_back_door_outlined),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (_) => TwoChoiceDialog(
                  title: 'Leave Room',
                  message: 'Do you want to leave this poker?',
                  onYes: () => invoke(context, () => poker.leaveRoom(),
                      (_) => GoRouter.of(context).go('/room')),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
