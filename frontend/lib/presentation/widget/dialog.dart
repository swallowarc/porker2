import 'package:flutter/material.dart';

class TwoChoiceDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function() onYes;
  final Function() onNo;

  const TwoChoiceDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onYes,
    required this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        GestureDetector(
          onTap: onYes,
          child: const Text('Yes'),
        ),
        GestureDetector(
          onTap: onNo,
          child: const Text('No'),
        )
      ],
    );
  }
}
