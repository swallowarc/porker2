import 'package:flutter/material.dart';

class TwoChoiceDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function() onYes;
  final Function()? onNo;

  const TwoChoiceDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onYes,
    this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              onYes();
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onNo ?? () => Navigator.pop(context),
            child: const Text('No'),
          ),
        ),
      ],
    );
  }
}
