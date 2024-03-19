import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/characters/presentation/character_search/character_search_tabbar_view.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_item_card.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/utils/adaptive_search_dialog.dart';
import 'package:flutter/material.dart';

class CharacterAddPage extends StatefulWidget {
  const CharacterAddPage({
    super.key,
    required this.characters,
    required this.onAddCharacterTap,
    required this.onRemoveCharacterTap,
    required this.onAddAnimeCharactersTap,
  });

  final Iterable<TierListItem> characters;
  final ValueChanged<TierListItem> onAddCharacterTap;
  final ValueChanged<TierListItem> onRemoveCharacterTap;
  final void Function(Anime, Iterable<TierListItem>) onAddAnimeCharactersTap;

  @override
  State<CharacterAddPage> createState() => _CharacterAddPageState();
}

class _CharacterAddPageState extends State<CharacterAddPage> {
  late Map<String, TierListItem> _charactersById;

  var _search = '';

  @override
  void initState() {
    super.initState();
    _charactersById = widget.characters.toMapById();
  }

  @override
  void didUpdateWidget(CharacterAddPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.characters != oldWidget.characters) {
      setState(() {
        _charactersById = widget.characters.toMapById();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveSearchDialog(
      title: Text(context.loc.characters_add_title),
      onChanged: _onSearchChanged,
      content: CharacterSearchTabBarView(
        search: _search,
        onAddAnimeCharactersTap: _onAddAnimeCharactersTap,
        itemBuilder: _buildItem,
      ),
    );
  }

  Widget _buildItem(BuildContext context, Character character, int index) {
    final itemId = character.itemId;

    final foundItem = _charactersById[itemId];
    final item = foundItem ?? TierListItem(id: itemId, value: character);

    return InkWell(
      onTap: () => foundItem != null //
          ? widget.onRemoveCharacterTap(item)
          : widget.onAddCharacterTap(item),
      child: Stack(
        children: [
          TierListItemCard(
            item: item,
          ),
          if (foundItem != null)
            Container(
              color: Colors.black54,
            ),
        ],
      ),
    );
  }

  void _onAddAnimeCharactersTap(Anime anime, Iterable<Character> characters) {
    widget.onAddAnimeCharactersTap(anime, characters.map((e) => TierListItem(id: e.itemId, value: e)));
  }

  void _onSearchChanged(String value) {
    setState(() {
      _search = value;
    });
  }
}
