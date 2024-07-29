import 'package:flutter/material.dart';
import 'package:porker2fe/presentation/const.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

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
