import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:flutter/material.dart';

class AnimeListTile extends StatelessWidget {
  const AnimeListTile({
    super.key,
    required this.anime,
    this.selected = false,
    this.dense,
    this.onTap,
  });

  final Anime anime;
  final bool selected;
  final bool? dense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      selected: selected,
      dense: dense,
      title: Text(
        anime.userPreferredTitle,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
