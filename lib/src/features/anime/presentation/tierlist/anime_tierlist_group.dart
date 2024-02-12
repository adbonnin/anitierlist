import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/anime/presentation/tierlist/anime_tierlist_card.dart';
import 'package:anitierlist/src/l10n/app_localization_extension.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/widgets/widget_to_image.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';

class AnimeTierListGroup extends StatelessWidget {
  const AnimeTierListGroup({
    super.key,
    required this.format,
    required this.animeImageControllers,
    required this.onAnimeTap,
  });

  final AnimeFormat format;
  final List<(Anime, WidgetToImageController)> animeImageControllers;
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
          children: animeImageControllers //
              .map((e) => _buildItem(e.$1, e.$2))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildItem(Anime anime, WidgetToImageController imageController) {
    return WidgetToImage(
      controller: imageController,
      child: AnimeTierListCard(
        anime,
        onTap: () => onAnimeTap(anime),
      ),
    );
  }
}
