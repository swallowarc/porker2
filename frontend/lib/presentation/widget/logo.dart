import 'package:flutter/material.dart';
import 'package:porker2fe/presentation/const.dart';

enum LogoType { login, roomSelect }

extension LogoTypeExtension on LogoType {
  String get imagePath {
    switch (this) {
      case LogoType.login:
        return "images/title.png";
      case LogoType.roomSelect:
        return "images/room-select.png";
    }
  }
}

class Logo extends StatelessWidget {
  final LogoType type;
  final String message;

  const Logo({super.key, required this.type, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen =
        MediaQuery.of(context).size.width < smallScreenBoundary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(
          fit: BoxFit.scaleDown,
          image: AssetImage(type.imagePath),
          height: 200,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            message,
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
