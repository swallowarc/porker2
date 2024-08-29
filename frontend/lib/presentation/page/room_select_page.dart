import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/domain/entity/room.dart';
import 'package:porker2fe/presentation/const.dart';
import 'package:porker2fe/presentation/invoke.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/app_bar.dart';
import 'package:porker2fe/presentation/widget/bottom_bar.dart';
import 'package:porker2fe/presentation/widget/logo.dart';

class RoomSelectPage extends HookConsumerWidget {
  const RoomSelectPage(this.roomId, {super.key});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      if (roomId.isNotEmpty) {
        final poker = ref.read(pokerProvider.notifier);
        invoke(context, () => poker.checkRoom(roomId),
            (_) => GoRouter.of(context).go('/poker?room-id=$roomId'));
      }

      return null; // クリーンアップが不要な場合はnullを返す
    }, []); // 空の依存配列を渡すことで、初回のみ実行

    final user = ref.watch(userProvider);
    if (user.userID.isEmpty) {
      GoRouter.of(context).go('/');
    }

    final bool isSmallScreen =
        MediaQuery.of(context).size.width < smallScreenBoundary;
    const logo =
        Logo(type: LogoType.roomSelect, message: "Join or Create a room");

    final body = Center(
      child: SingleChildScrollView(
        child: isSmallScreen
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  logo,
                  _FormContent(),
                ],
              )
            : Container(
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 800),
                child: Row(
                  children: [
                    const Expanded(child: logo),
                    Expanded(
                      child: Center(child: _FormContent()),
                    ),
                  ],
                ),
              ),
      ),
    );

    return Scaffold(
      appBar: Porker2AppBar(
        title: 'Welcome, ${user.userName}',
        enableDrawer: false,
        enableLogout: true,
      ),
      body: body,
      bottomNavigationBar: const BottomBar(),
    );
  }
}

class _FormContent extends HookConsumerWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokerNotifier = ref.read(pokerProvider.notifier);
    final TextEditingController roomIDController = TextEditingController();
    final bool isSmallScreen =
        MediaQuery.of(context).size.width < smallScreenBoundary;

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: roomIDController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(roomIDCharRegExp),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter room ID  (；´Д｀)';
                }

                return roomIDFormatRegExp.hasMatch(value)
                    ? null
                    : 'Please enter a valid ID (5 digits)';
              },
              maxLength: 5,
              maxLines: 1,
              decoration: const InputDecoration(
                labelText: 'Room ID',
                hintText: 'Enter room ID',
                prefixIcon: Icon(Icons.edit),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Join',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final roomId = roomIDController.text;
                    invoke(
                        context,
                        () => pokerNotifier.checkRoom(roomId),
                        (_) =>
                            GoRouter.of(context).go('/poker?room-id=$roomId'));
                  }
                },
              ),
            ),
            _gap(),
            Text(
              "or",
              textAlign: TextAlign.center,
              style: isSmallScreen
                  ? Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.orange, fontSize: 24)
                  : Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.orange, fontSize: 24),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Create a room',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  invoke(
                      context,
                      () => pokerNotifier.createRoom(),
                      (roomID) =>
                          GoRouter.of(context).go('/poker?room-id=$roomID'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 12);
}
