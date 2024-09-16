import 'package:flutter/material.dart';
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
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(userProvider.notifier).verifyUser().then((verified) {
        logger.d("User verified: $verified");
        if (verified && context.mounted) {
          _next(context, ref);
        }
      });
      return null;
    }, []);

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
      resizeToAvoidBottomInset: true,
      appBar: const Porker2AppBar(
        title: "Welcome to Porker2",
        enableDrawer: false,
        enableLogout: false,
        enableCopyRoomURL: false,
      ),
      body: body,
      bottomNavigationBar: const BottomBar(),
    );
  }
}

class _FormContent extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // restore last user name
    final userNameController = useTextEditingController();
    final focusNode = useFocusNode();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    useEffect(() {
      ref.read(userProvider.notifier).latestUserName().then((value) {
        userNameController.text = value;
      });
      return null;
    }, []);

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              focusNode: focusNode,
              controller: userNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text  (´・ω・`)';
                }

                return userNameFormatRegExp.hasMatch(value)
                    ? null
                    : 'Please enter ([a-zA-Z0-9_-]{1,10})';
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
                  if (formKey.currentState?.validate() ?? false) {
                    final userNotifier = ref.read(userProvider.notifier);
                    invoke(
                      context,
                      () => userNotifier.login(userNameController.text),
                      (_) => _next(context, ref),
                    );
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

void _next(BuildContext context, WidgetRef ref) {
  final presetRoomID =
      ref.read(directRoomJoinProvider.notifier).popPresetRoomID();

  if (presetRoomID.isNotEmpty) {
    invoke(
      context,
      () => ref.read(pokerProvider.notifier).checkRoom(presetRoomID),
      (_) => GoRouter.of(context).go('/poker?room-id=$presetRoomID'),
    );
    return;
  }

  GoRouter.of(context).go('/room');
}
