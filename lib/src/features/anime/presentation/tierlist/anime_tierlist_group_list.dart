import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/anime/presentation/tierlist/anime_tierlist_card.dart';
import 'package:anitierlist/src/features/anime/presentation/tierlist/anime_tierlist_group.dart';
import 'package:anitierlist/src/utils/iterable_extensions.dart';
import 'package:anitierlist/src/widgets/screenshot.dart';
import 'package:anitierlist/styles.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class AnimeTierListGroupList extends StatefulWidget {
  const AnimeTierListGroupList({
    super.key,
    required this.anime,
    required this.onAnimeTap,
  });

  final List<Anime> anime;
  final void Function(Anime) onAnimeTap;

  @override
  State<AnimeTierListGroupList> createState() => AnimeTierListGroupListState();
}

class AnimeTierListGroupListState extends State<AnimeTierListGroupList> {
  late List<ScreenshotController> _screenshotControllers;

  @override
  void initState() {
    super.initState();
    _screenshotControllers = List.generate(widget.anime.length, (_) => ScreenshotController());
  }

  @override
  void didUpdateWidget(AnimeTierListGroupList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.anime.length != oldWidget.anime.length) {
      _screenshotControllers = List.generate(widget.anime.length, (_) => ScreenshotController());
    }
  }

  @override
  void dispose() {
    _screenshotControllers = [];
    super.dispose();
  }

  Map<AnimeFormat, List<(Anime, ScreenshotController)>> buildAnimeScreenshotsByFormat() {
    return widget.anime //
        .mapIndexed((i, a) => (a, _screenshotControllers[i]))
        .groupListsBy((element) => element.$1.format);
  }

  @override
  Widget build(BuildContext context) {
    final animeScreenshotsByFormat = buildAnimeScreenshotsByFormat();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: animeScreenshotsByFormat.entries //
          .where((etr) => etr.value.isNotEmpty)
          .map((etr) => _build(etr.key, etr.value))
          .intersperse((_, __) => Gaps.p18)
          .toList(),
    );
  }

  Widget _build(AnimeFormat format, List<(Anime, ScreenshotController)> animeScreenshots) {
    return AnimeTierListGroup(
      format: format,
      children: animeScreenshots.map(_buildItem).toList(),
    );
  }

  Widget _buildItem((Anime, ScreenshotController) animeScreenshot) {
    return Screenshot(
      controller: animeScreenshot.$2,
      child: AnimeTierListCard(
        animeScreenshot.$1,
        onTap: () => widget.onAnimeTap(animeScreenshot.$1),
      ),
    );
  }
}
