import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/anime/presentation/tierlist/anime_tierlist_card.dart';
import 'package:anitierlist/src/l10n/app_localization_extension.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/widgets/screenshot.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';

class AnimeTierListGroup extends StatelessWidget {
  const AnimeTierListGroup({
    super.key,
    required this.format,
    required this.animeScreenshots,
    required this.onAnimeTap,
  });

  final AnimeFormat format;
  final List<(Anime, ScreenshotController)> animeScreenshots;
  final ValueChanged<Anime> onAnimeTap;

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
          children: animeScreenshots //
              .map((e) => _buildItem(e.$1, e.$2))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildItem(Anime anime, ScreenshotController screenshotController) {
    return Screenshot(
      controller: screenshotController,
      child: AnimeTierListCard(
        anime,
        onTap: () => onAnimeTap(anime),
      ),
    );
  }
}
