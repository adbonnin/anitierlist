import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/anime/presentation/anime_search/anime_search_view.dart';
import 'package:anitierlist/src/features/characters/presentation/character_search/character_search_anime_card.dart';
import 'package:anitierlist/src/features/characters/presentation/character_search/character_search_view.dart';
import 'package:flutter/material.dart';

class CharacterSearchAnimeTab extends StatelessWidget {
  const CharacterSearchAnimeTab({
    super.key,
    required this.search,
    required this.itemBuilder,
  });

  final String search;
  final CharacterWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: AnimeSearchView(
            search: search,
            itemBuilder: _build,
          ),
        ),
      ],
    );
  }

  Widget _build(BuildContext context, Anime anime, int index) {
    return CharacterSearchAnimeCard(
      title: anime.title,
    );
  }
}
