import 'package:material_ui/material_ui.dart';

class TwoChoiceDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onYes;
  final VoidCallback? onNo;

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
        TextButton(
          onPressed: onNo ?? () => Navigator.pop(context),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onYes();
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
