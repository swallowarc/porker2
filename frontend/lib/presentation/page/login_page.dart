import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/domain/entity/user.dart';
import 'package:porker2fe/presentation/const.dart';
import 'package:porker2fe/presentation/invoke.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/app_bar.dart';
import 'package:porker2fe/presentation/widget/bottom_bar.dart';
import 'package:porker2fe/presentation/widget/logo.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage(this.roomId, {super.key});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      final result = ref.read(userProvider.notifier).verifyUser();
      result.then((verified) {
        logger.d("User verified: $verified");

        if (verified && context.mounted) {
          if (roomId.isNotEmpty) {
            GoRouter.of(context).go('/room?room-id=$roomId');
          } else {
            GoRouter.of(context).go('/room');
          }
        }
      });

      return null; // クリーンアップが不要な場合はnullを返す
    }, []); // 空の依存配列を渡すことで、初回のみ実行

    const logo = Logo(type: LogoType.login, message: "Enter your name");
    final bool isSmallScreen =
        MediaQuery.of(context).size.width < smallScreenBoundary;

    final body = Center(
      child: SingleChildScrollView(
        child: isSmallScreen
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  logo,
                  _FormContent(roomId),
                ],
              )
            : Container(
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 800),
                child: Row(
                  children: [
                    const Expanded(child: logo),
                    Expanded(
                      child: Center(child: _FormContent(roomId)),
                    ),
                  ],
                ),
              ),
      ),
    );

    return Scaffold(
      appBar: const Porker2AppBar(
        title: "Welcome to Porker2",
        enableDrawer: false,
        enableLogout: false,
      ),
      body: body,
      bottomNavigationBar: const BottomBar(),
    );
  }
}

class _FormContent extends HookConsumerWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final String roomId;

  _FormContent(this.roomId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // restore last user name
    final TextEditingController userNameController = TextEditingController();
    ref.read(userProvider.notifier).latestUserName().then((value) {
      userNameController.text = value;
    });

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: userNameController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(userNameCharRegExp),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text  (´・ω・`)';
                }

                return userNameFormatRegExp.hasMatch(value)
                    ? null
                    : 'Please enter a valid name (alphabet or number)';
              },
              maxLength: 10,
              maxLines: 1,
              decoration: const InputDecoration(
                labelText: 'User name',
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.edit),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (roomId.isNotEmpty) {
                      invoke(
                          context,
                          () => ref
                              .read(userProvider.notifier)
                              .login(userNameController.text),
                          (_) =>
                              GoRouter.of(context).go('/room?room-id=$roomId'));
                    } else {
                      invoke(
                          context,
                          () => ref
                              .read(userProvider.notifier)
                              .login(userNameController.text),
                          (_) => GoRouter.of(context).go('/room'));
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
