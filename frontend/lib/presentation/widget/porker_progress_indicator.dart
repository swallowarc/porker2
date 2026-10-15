import 'package:material_ui/material_ui.dart';

class PorkerProgressIndicator extends StatelessWidget {
  const PorkerProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
