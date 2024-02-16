import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    this.body,
  });

  final Widget? body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1024),
          padding: const EdgeInsets.symmetric(vertical: Insets.p16, horizontal: Insets.p8),
          child: body,
        ),
      ),
    );
  }
}
