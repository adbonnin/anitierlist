import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';

class ExpandedRadioListTile<T> extends StatelessWidget {
  const ExpandedRadioListTile({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
    this.onCopyPressed,
    required this.title,
    required this.subtitle,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final VoidCallback? onCopyPressed;
  final Widget title;
  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            title: title,
            subtitle: subtitle,
            dense: true,
            visualDensity: const VisualDensity(
              vertical: VisualDensity.minimumDensity,
            ),
          ),
        ),
        if (onCopyPressed != null) ...[
          Gaps.p6,
          IconButton.outlined(
            onPressed: onCopyPressed,
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
        ],
      ],
    );
  }
}
