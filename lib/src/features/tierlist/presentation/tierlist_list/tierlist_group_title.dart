import 'package:flutter/material.dart';

class TierListGroupTitle extends StatelessWidget {
  const TierListGroupTitle({
    super.key,
    required this.titleText,
  });

  final String titleText;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Text(
      titleText,
      style: textTheme.headlineSmall,
    );
  }
}
