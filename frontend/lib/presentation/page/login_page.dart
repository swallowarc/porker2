import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/domain/entity/user.dart';
import 'package:porker2fe/presentation/const.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSmallScreen =
        MediaQuery.of(context).size.width < smallScreenBoundary;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: isSmallScreen
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Logo(),
                    _FormContent(),
                  ],
                )
              : Container(
                  padding: const EdgeInsets.all(32.0),
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: const Row(
                    children: [
                      Expanded(child: _Logo()),
                      Expanded(
                        child: Center(child: _FormContent()),
                      ),
                    ],
                  ),
                ),
        ),
      ),
      bottomNavigationBar: const _BottomBar(),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen =
        MediaQuery.of(context).size.width < smallScreenBoundary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Image(
          fit: BoxFit.scaleDown,
          image: AssetImage("images/title.png"),
          height: 200,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Welcome to Porker2",
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
        )
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Please enter some text (´・ω・`)';
                }

                bool emailValid = userNameRegExp.hasMatch(value);
                if (!emailValid) {
                  return 'Please enter a valid name (alphabet or number)';
                }

                context.go('/?from=123');

                return null;
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
                    /// do something
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

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Tooltip(
              message: 'GitHub',
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _launchGithub,
                  child: Image(
                    fit: BoxFit.scaleDown,
                    image: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? const AssetImage("images/github-mark-white.png")
                        : const AssetImage("images/github-mark.png"),
                    height: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchGithub() async {
    final Uri url = Uri.parse(githubUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
