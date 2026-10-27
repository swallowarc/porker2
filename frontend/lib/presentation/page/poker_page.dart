import 'package:material_ui/material_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/presentation/const.dart';
import 'package:porker2fe/presentation/invoke.dart';
import 'package:porker2fe/application/provider.dart';
import 'package:porker2fe/presentation/router/router.dart';
import 'package:porker2fe/presentation/widget/app_bar.dart';
import 'package:porker2fe/presentation/widget/bottom_bar.dart';
import 'package:porker2fe/presentation/widget/dialog.dart';
import 'package:porker2fe/presentation/widget/fireworks.dart';
import 'package:porker2fe/presentation/widget/poker/field_cards.dart';
import 'package:porker2fe/presentation/widget/poker/hand_cards.dart';
import 'package:porker2fe/presentation/widget/poker/summary.dart';
import 'package:porker2fe/presentation/widget/poker/vote_buttons.dart';
import 'package:porker2fe/presentation/widget/porker_progress_indicator.dart';

class PokerPage extends HookConsumerWidget {
  const PokerPage(this.roomId, {super.key});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 未ログインでの到達は router の redirect が防いでいるので、ここでは入室だけを行う。
    // joinRoom は購読が終わる (退室・キック・部屋の消滅) まで完了しないので、
    // 完了したら部屋選択へ戻る。エラー (部屋がない・満員など) は invoke が表示してから
    // 部屋選択へ戻し、Unauthenticated ならログインへ戻す
    useEffect(() {
      logger.d('join room: $roomId');
      invoke(
        context,
        () => ref.read(pokerProvider.notifier).joinRoom(roomId),
        (_) => RoomSelectRoute().go(context),
        onError: () => RoomSelectRoute().go(context),
      );
      return null;
    }, [roomId]);

    final poker = ref.watch(pokerProvider);
    if (poker.roomID.isEmpty) {
      return const PorkerProgressIndicator();
    }

    final bool isMediumScreen =
        MediaQuery.of(context).size.width < mediumScreenBoundary;

    final body = Stack(
      children: [
        if (ref.read(pokerProvider.notifier).isUnanimity)
          const Positioned.fill(child: FireWorks()),
        const Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FieldCards(),
                Summary(),
                VoteButtons(),
                SizedBox(height: 30),
                HandCards(),
              ],
            ),
          ),
        )
      ],
    );

    return Scaffold(
      appBar: Porker2AppBar(
        title: 'Room ID: ${poker.roomID}',
        enableDrawer: true,
        enableLogout: true,
        enableCopyRoomURL: true,
        onLeave: () {
          showDialog<void>(
            context: context,
            builder: (_) => TwoChoiceDialog(
              title: 'Leave Room',
              message: 'Do you want to leave this poker?',
              onYes: () => invoke(
                  context,
                  () => ref.read(pokerProvider.notifier).leaveRoom(),
                  (_) => RoomSelectRoute().go(context)),
            ),
          );
        },
      ),
      body: Row(
        children: [
          isMediumScreen ? Container() : _Drawer(),
          Expanded(child: body),
        ],
      ),
      drawer: isMediumScreen ? _Drawer() : null,
      bottomNavigationBar: const BottomBar(),
    );
  }

}

class _Drawer extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokerNotifier = ref.read(pokerProvider.notifier);
    final poker = ref.watch(pokerProvider);
    final user = ref.watch(userProvider);

    return Drawer(
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 60, // ヘッダーの高さを指定
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(16),
              child: Text(user.userName),
            ),
          ),
          // Room Settings Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Room Settings',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Auto open'),
            subtitle: const Text('Reveal when all voted', style: TextStyle(fontSize: 12)),
            secondary: const Icon(Icons.flash_auto),
            value: poker.autoOpen,
            onChanged: (bool value) {
              invoke(context, () => pokerNotifier.updateRoom(value, poker.displayMode), (_) {});
            },
          ),
          SwitchListTile(
            title: const Text('T-shirt mode'),
            subtitle: const Text('Use T-shirt sizes', style: TextStyle(fontSize: 12)),
            secondary: const Icon(Icons.checkroom),
            value: poker.displayMode == DisplayMode.DISPLAY_MODE_TSHIRT,
            onChanged: (bool value) {
              final newMode = value ? DisplayMode.DISPLAY_MODE_TSHIRT : DisplayMode.DISPLAY_MODE_POINT;
              invoke(context, () => pokerNotifier.updateRoom(poker.autoOpen, newMode), (_) {});
            },
          ),
          const Divider(thickness: 1, height: 32),
          // Personal Settings Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Personal Settings',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Observer mode'),
            subtitle: const Text('Watch without voting', style: TextStyle(fontSize: 12)),
            secondary: const Icon(Icons.visibility),
            value: pokerNotifier.isObserver(user.userID),
            onChanged: (bool value) {
              invoke(context, () => pokerNotifier.toggleObserverMode(value), (_) {});
            },
          ),
        ],
      ),
    );
  }
}
