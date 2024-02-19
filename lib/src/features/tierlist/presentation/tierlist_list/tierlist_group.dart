import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';

class TierListGroup extends StatelessWidget {
  const TierListGroup({
    super.key,
    required this.labelText,
    required this.children,
  });

  final String? labelText;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: textTheme.headlineSmall,
          ),
          Gaps.p6,
        ],
        Wrap(
          spacing: Insets.p6,
          runSpacing: Insets.p6,
          children: children,
        ),
      ],
    );
  }
}
