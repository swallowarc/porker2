import 'package:flutter/material.dart';

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
