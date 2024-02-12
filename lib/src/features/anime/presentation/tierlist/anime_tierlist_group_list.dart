import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/anime/presentation/tierlist/anime_tierlist_group.dart';
import 'package:anitierlist/src/utils/iterable_extensions.dart';
import 'package:anitierlist/src/widgets/widget_to_image.dart';
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
  late List<WidgetToImageController> imageControllers;

  @override
  void initState() {
    super.initState();
    imageControllers = List.generate(widget.anime.length, (_) => WidgetToImageController());
  }

  @override
  void didUpdateWidget(AnimeTierListGroupList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.anime.length != oldWidget.anime.length) {
      imageControllers = List.generate(widget.anime.length, (_) => WidgetToImageController());
    }
  }

  @override
  void dispose() {
    imageControllers = [];
    super.dispose();
  }

  Map<AnimeFormat, List<(Anime, WidgetToImageController)>> buildAnimeByFormat() {
    return widget.anime //
        .mapIndexed((i, a) => (a, imageControllers[i]))
        .groupListsBy((element) => element.$1.format);
  }

  @override
  Widget build(BuildContext context) {
    final animeByFormat = buildAnimeByFormat();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: animeByFormat.entries //
          .where((etr) => etr.value.isNotEmpty)
          .map((etr) => _build(etr.key, etr.value))
          .intersperse((_, __) => Gaps.p18)
          .toList(),
    );
  }

  Widget _build(AnimeFormat format, List<(Anime, WidgetToImageController)> animeImageControllers) {
    return AnimeTierListGroup(
      format: format,
      animeImageControllers: animeImageControllers,
      onAnimeTap: widget.onAnimeTap,
    );
  }
}
