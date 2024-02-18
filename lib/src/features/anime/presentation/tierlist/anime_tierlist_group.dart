import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/l10n/app_localization_extension.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';

class AnimeTierListGroup extends StatelessWidget {
  const AnimeTierListGroup({
    super.key,
    required this.format,
    required this.children,
  });

  final AnimeFormat format;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.loc.animeFormat(format),
          style: textTheme.headlineSmall,
        ),
        Gaps.p6,
        Wrap(
          spacing: Insets.p6,
          runSpacing: Insets.p6,
          children: children,
        ),
      ],
    );
  }
}
