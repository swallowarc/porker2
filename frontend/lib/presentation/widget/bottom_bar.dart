import 'package:material_ui/material_ui.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/presentation/const.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width < smallScreenBoundary) {
      return const SizedBox.shrink();
    }
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
                    image: MediaQuery.platformBrightnessOf(context) ==
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
    // GestureDetector の onTap からは例外を受け取れないので、失敗はログに留める
    if (!await launchUrl(url)) {
      logger.w('Could not launch $url');
    }
  }
}
