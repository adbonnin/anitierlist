import 'package:anitierlist/src/features/characters/application/character_service.dart';
import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/characters/presentation/character_paged_grid_view.dart';
import 'package:anitierlist/src/utils/graphql.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterSearchCharacterTab extends ConsumerStatefulWidget {
  const CharacterSearchCharacterTab({
    super.key,
    required this.search,
    required this.itemBuilder,
  });

  final String search;
  final CharacterWidgetBuilder itemBuilder;

  @override
  ConsumerState<CharacterSearchCharacterTab> createState() => _CharacterSearchCharacterTabState();
}

class _CharacterSearchCharacterTabState extends ConsumerState<CharacterSearchCharacterTab> {
  late PagedItemFinder<Character> _characterFinder;

  @override
  void initState() {
    super.initState();
    _characterFinder = _buildFinder(widget.search);
  }

  @override
  void didUpdateWidget(CharacterSearchCharacterTab oldWidget) {
    if (widget.search != oldWidget.search) {
      _characterFinder = _buildFinder(widget.search);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.p8),
      child: CharacterPagedGridView(
        itemFinder: _characterFinder,
        itemBuilder: widget.itemBuilder,
      ),
    );
  }

  PagedItemFinder<Character> _buildFinder(String? search) {
    return (int page) => ref.read(characterServiceProvider).searchCharacters(search, page);
  }
}
