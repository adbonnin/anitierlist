import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';

class TierListGroup extends StatelessWidget {
  const TierListGroup({
    super.key,
    required this.title,
    required this.children,
  });

  final Widget? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null) ...[
          title!,
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
