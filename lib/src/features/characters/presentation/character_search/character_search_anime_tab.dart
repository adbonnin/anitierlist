import 'package:anitierlist/src/features/anime/application/anime_service.dart';
import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/anime/presentation/anime_paged_list_view.dart';
import 'package:anitierlist/src/features/characters/application/character_service.dart';
import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/characters/presentation/character_paged_grid_view.dart';
import 'package:anitierlist/src/features/characters/presentation/character_search/character_search_anime_list_tile.dart';
import 'package:anitierlist/src/utils/graphql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterSearchAnimeTab extends ConsumerStatefulWidget {
  const CharacterSearchAnimeTab({
    super.key,
    required this.search,
    required this.itemBuilder,
  });

  final String search;
  final CharacterWidgetBuilder itemBuilder;

  @override
  ConsumerState<CharacterSearchAnimeTab> createState() => _CharacterSearchAnimeTabState();
}

class _CharacterSearchAnimeTabState extends ConsumerState<CharacterSearchAnimeTab> {
  late PagedItemFinder<Anime> _animeFinder;
  late PagedItemFinder<Character>? _characterFinder;

  @override
  void initState() {
    super.initState();
    _animeFinder = _buildAnimeFinder(widget.search);
    _characterFinder = null;
  }

  @override
  void didUpdateWidget(CharacterSearchAnimeTab oldWidget) {
    if (widget.search != oldWidget.search) {
      _animeFinder = _buildAnimeFinder(widget.search);
      _characterFinder = null;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: AnimePagedListView(
            itemFinder: _animeFinder,
            itemBuilder: _buildAnimeItem,
          ),
        ),
        if (_characterFinder != null)
          Expanded(
            flex: 2,
            child: CharacterPagedGridView(
              itemFinder: _characterFinder!,
              itemBuilder: widget.itemBuilder,
            ),
          ),
      ],
    );
  }

  PagedItemFinder<Anime> _buildAnimeFinder(String? search) {
    final service = ref.read(animeServiceProvider);
    return (int page) => service.searchAnime(search, page);
  }

  PagedItemFinder<Character>? _buildCharacterFinder(int? animeId) {
    final service = ref.read(characterServiceProvider);
    return animeId == null ? null : (page) => service.browseAnimeCharacters(animeId, page);
  }

  Widget _buildAnimeItem(BuildContext context, Anime anime, int index) {
    return CharacterSearchAnimeListTile(
      title: anime.title,
      onTap: () => _onAnimeTap(anime),
    );
  }

  void _onAnimeTap(Anime anime) {
    setState(() {
      _characterFinder = _buildCharacterFinder(anime.id);
    });
  }
}
