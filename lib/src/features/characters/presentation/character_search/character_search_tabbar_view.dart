import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/characters/presentation/character_paged_grid_view.dart';
import 'package:anitierlist/src/features/characters/presentation/character_search/character_search_anime_tab.dart';
import 'package:anitierlist/src/features/characters/presentation/character_search/character_search_character_tab.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CharacterSearchTabBarView extends StatelessWidget {
  const CharacterSearchTabBarView({
    super.key,
    required this.search,
    required this.onAddAnimeCharactersTap,
    required this.itemBuilder,
  });

  final String search;
  final void Function(Anime, List<Character>) onAddAnimeCharactersTap;
  final CharacterWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(tabs: [
            Tab(text: context.loc.characters_searchCharacters),
            Tab(text: context.loc.characters_searchAnime),
          ]),
          Expanded(
            child: TabBarView(
              children: [
                CharacterSearchCharacterTab(
                  search: search,
                  itemBuilder: itemBuilder,
                ),
                CharacterSearchAnimeTab(
                  search: search,
                  onAddAnimeCharactersTap: onAddAnimeCharactersTap,
                  itemBuilder: itemBuilder,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
