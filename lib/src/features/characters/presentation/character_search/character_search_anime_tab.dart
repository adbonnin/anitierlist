import 'package:anitierlist/src/features/anime/application/anime_service.dart';
import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/anime/presentation/anime_list_tile.dart';
import 'package:anitierlist/src/features/anime/presentation/anime_paged_list_view.dart';
import 'package:anitierlist/src/features/characters/application/character_service.dart';
import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/characters/presentation/character_paged_grid_view.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/utils/graphql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterSearchAnimeTab extends ConsumerStatefulWidget {
  const CharacterSearchAnimeTab({
    super.key,
    required this.search,
    required this.onAddAnimeCharactersTap,
    required this.itemBuilder,
  });

  final String search;
  final void Function(Anime, List<Character>) onAddAnimeCharactersTap;
  final CharacterWidgetBuilder itemBuilder;

  @override
  ConsumerState<CharacterSearchAnimeTab> createState() => _CharacterSearchAnimeTabState();
}

class _CharacterSearchAnimeTabState extends ConsumerState<CharacterSearchAnimeTab> {
  final _controller = PageController();

  Anime? _selectedAnime;
  late PagedItemFinder<Anime> _animeFinder;
  late PagedItemFinder<Character>? _characterFinder;

  @override
  void initState() {
    super.initState();
    _selectedAnime = null;
    _animeFinder = _buildAnimeFinder(widget.search);
    _characterFinder = null;
  }

  @override
  void didUpdateWidget(CharacterSearchAnimeTab oldWidget) {
    if (widget.search != oldWidget.search) {
      _selectedAnime = null;
      _animeFinder = _buildAnimeFinder(widget.search);
      _characterFinder = null;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        AnimePagedListView(
          itemFinder: _animeFinder,
          itemBuilder: _buildAnimeItem,
        ),
        if (_characterFinder != null)
          Column(
            children: [
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _onBackPressed,
                    icon: const Icon(Icons.arrow_back),
                    label: Text(context.loc.common_back),
                  ),
                  IconButton(
                    icon: const Icon(Icons.group_add),
                    tooltip: context.loc.characters_addAllAnimeCharacters,
                    onPressed: _onAddAnimeCharacters,
                  )
                ],
              ),
              Expanded(
                child: CharacterPagedGridView(
                  itemFinder: _characterFinder!,
                  itemBuilder: widget.itemBuilder,
                ),
              ),
            ],
          ),
      ],
    );
  }

  PagedItemFinder<Anime> _buildAnimeFinder(String? search) {
    final service = ref.read(animeServiceProvider);
    return (int page) => service.searchPagedAnime(search: search, page: page);
  }

  PagedItemFinder<Character>? _buildCharacterFinder(int? animeId) {
    final service = ref.read(characterServiceProvider);
    return animeId == null ? null : (page) => service.browsePagedAnimeCharacters(animeId: animeId, page: page);
  }

  Widget _buildAnimeItem(BuildContext context, Anime anime, int index) {
    return AnimeListTile(
      anime: anime,
      dense: true,
      selected: anime == _selectedAnime,
      onTap: () => _onAnimeTap(anime),
    );
  }

  void _onAnimeTap(Anime anime) {
    setState(() {
      _selectedAnime = anime;
      _characterFinder = _buildCharacterFinder(anime.id);
    });

    _animateToPage(1);
  }

  void _onBackPressed() {
    _animateToPage(0);
  }

  Future<void> _onAddAnimeCharacters() async {
    final service = ref.read(characterServiceProvider);
    final anime = _selectedAnime;

    if (anime == null) {
      return;
    }

    final characters = await service.browseAnimeCharacters(animeId: anime.id);
    widget.onAddAnimeCharactersTap(anime, characters);
  }

  Future<void> _animateToPage(int page) {
    return _controller.animateToPage(
      page,
      duration: kTabScrollDuration,
      curve: Curves.easeInOut,
    );
  }
}
