import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/presentation/const.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/app_bar.dart';
import 'package:porker2fe/presentation/widget/poker/field_cards.dart';
import 'package:porker2fe/presentation/widget/poker/hand_cards.dart';
import 'package:porker2fe/presentation/widget/poker/vote_buttons.dart';

class PokerPage extends HookConsumerWidget {
  const PokerPage(this.roomId, {super.key});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      final poker = ref.read(pokerProvider);
      poker.joinRoom(roomId);

      return null; // クリーンアップが不要な場合はnullを返す
    }, []); // 空の依存配列を渡すことで、初回のみ実行

    final bool isMediumScreen =
        MediaQuery.of(context).size.width < mediumScreenBoundary;

    final body = Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            FieldCards(),
            VoteButtons(),
            const SizedBox(height: 30),
            const HandCards(),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: Porker2AppBar(
          title: 'Room ID: $roomId',
          enableDrawer: true,
          enableLeaveRoom: true,
          enableLogout: true),
      body: Row(
        children: [
          isMediumScreen ? Container() : _Drawer(),
          Expanded(child: body),
        ],
      ),
      drawer: isMediumScreen ? _Drawer() : null,
    );
  }
}

class _Drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
