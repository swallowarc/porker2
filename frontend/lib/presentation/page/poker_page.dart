import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/domain/usecase/poker.dart';
import 'package:porker2fe/presentation/const.dart';
import 'package:porker2fe/presentation/invoke.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/app_bar.dart';
import 'package:porker2fe/presentation/widget/dialog.dart';
import 'package:porker2fe/presentation/widget/fireworks.dart';
import 'package:porker2fe/presentation/widget/poker/field_cards.dart';
import 'package:porker2fe/presentation/widget/poker/hand_cards.dart';
import 'package:porker2fe/presentation/widget/poker/vote_buttons.dart';
import 'package:porker2fe/presentation/widget/porker_progress_indicator.dart';

final List<Point> _fireworksTargetPoints = [
  Point.POINT_0,
  Point.POINT_0_5,
  Point.POINT_1,
  Point.POINT_2,
  Point.POINT_3,
  Point.POINT_5,
  Point.POINT_8,
  Point.POINT_13,
  Point.POINT_21
];

class PokerPage extends HookConsumerWidget {
  const PokerPage(this.roomId, {super.key});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      if (ref.read(userProvider).userID.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(directRoomJoinProvider.notifier).setPresetRoomID(roomId);
          GoRouter.of(context).go('/');
        });
        return null;
      }

      ref.read(pokerProvider.notifier).joinRoom(roomId);
      logger.d('join room: $roomId');

      return null; // クリーンアップが不要な場合はnullを返す
    }, []); // 空の依存配列を渡すことで、初回のみ実行

    if (ref.read(directRoomJoinProvider.notifier).hasPresetRoomID) {
      return const PorkerProgressIndicator();
    }

    final poker = ref.watch(pokerProvider);
    if (!ref.read(pokerProvider.notifier).subscribing) {
      logger.d('not subscribing');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GoRouter.of(context).go('/room');
      });
      return const PorkerProgressIndicator();
    }

    if (poker.roomID.isEmpty) {
      return const PorkerProgressIndicator();
    }

    final bool isMediumScreen =
        MediaQuery.of(context).size.width < mediumScreenBoundary;

    final body = Stack(
      children: [
        _isUnanimity(poker) ? const FireWorks() : Container(),
        const Center(
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
        )
      ],
    );

    return Scaffold(
      appBar: Porker2AppBar(
        title: 'Room ID: ${poker.roomID}',
        enableDrawer: true,
        enableLogout: true,
        enableCopyRoomURL: true,
      ),
      body: Row(
        children: [
          isMediumScreen ? Container() : _Drawer(),
          Expanded(child: body),
        ],
      ),
      drawer: isMediumScreen ? _Drawer() : null,
    );
  }

  bool _isUnanimity(PokerState state) {
    if (state.ballots.length < 2) {
      return false;
    }

    if (state.voteState != VoteState.VOTE_STATE_OPEN) {
      return false;
    }

    final firstPoint = state.ballots.first.point;
    if (!_fireworksTargetPoints.contains(firstPoint)) {
      return false;
    }

    for (final ballot in state.ballots) {
      if (ballot.point != firstPoint) {
        return false;
      }
    }

    return true;
  }
}

class _Drawer extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokerNotifier = ref.read(pokerProvider.notifier);
    final poker = ref.watch(pokerProvider);
    final user = ref.watch(userProvider);

    return Drawer(
      width: 200,
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
          ListTile(
            title: const Text('Leave room'),
            leading: const Icon(Icons.door_back_door_outlined),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (_) => TwoChoiceDialog(
                  title: 'Leave Room',
                  message: 'Do you want to leave this poker?',
                  onYes: () => invoke(context, () => pokerNotifier.leaveRoom(),
                      (_) => GoRouter.of(context).go('/room')),
                ),
              );
            },
          ),
          SwitchListTile(
            title: const Text('Auto open'),
            value: poker.autoOpen,
            onChanged: (bool value) {
              invoke(context, () => pokerNotifier.updateRoom(value), (_) {});
            },
          ),
        ],
      ),
    );
  }
}
