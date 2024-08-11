import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/presentation/const.dart';
import 'package:porker2fe/presentation/widget/app_bar.dart';
import 'package:porker2fe/presentation/widget/bottom_bar.dart';

class PokerPage extends HookConsumerWidget {
  const PokerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isMediumScreen =
        MediaQuery.of(context).size.width < mediumScreenBoundary;

    final body = Center(
      child: SingleChildScrollView(),
    );

    return Scaffold(
      appBar: const Porker2AppBar(title: "Room ID: 12345", enableDrawer: true),
      body: Row(
        children: [
          isMediumScreen ? Container() : _Drawer(),
          body,
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
