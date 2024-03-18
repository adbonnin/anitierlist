import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/characters/presentation/character_search/character_search_tabbar_view.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_item_card.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/utils/adaptive_search_dialog.dart';
import 'package:anitierlist/src/widgets/toast.dart';
import 'package:flutter/material.dart';

void showCharacterAddDialog({
  required BuildContext context,
  Set<TierListItem> initialCharacters = const {},
  required void Function(Set<TierListItem>) onCharactersChanged,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return CharacterAddDialog(
        initialCharacters: initialCharacters,
        onCharactersChanged: onCharactersChanged,
      );
    },
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}

class CharacterAddDialog extends StatefulWidget {
  const CharacterAddDialog({
    super.key,
    this.initialCharacters = const {},
    required this.onCharactersChanged,
  });

  final Set<TierListItem> initialCharacters;
  final void Function(Set<TierListItem> character) onCharactersChanged;

  @override
  State<CharacterAddDialog> createState() => _CharacterAddDialogState();
}

class _CharacterAddDialogState extends State<CharacterAddDialog> {
  var _search = '';
  late Map<String, TierListItem> _charactersByIds;

  @override
  void initState() {
    super.initState();
    _charactersByIds = widget.initialCharacters.toMapById();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveSearchDialog(
      title: Text(context.loc.characters_add_title),
      onChanged: _onChanged,
      content: CharacterSearchTabBarView(
        search: _search,
        onAddAnimeCharactersTap: _onAddAnimeCharactersTap,
        itemBuilder: _buildItem,
      ),
    );
  }

  Widget _buildItem(BuildContext context, Character character, int index) {
    final itemId = character.itemId;

    final foundItem = _charactersByIds[itemId];
    final item = foundItem ?? TierListItem(id: itemId, value: character);

    return InkWell(
      onTap: () => _onCharacterTap(character),
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

  void _onChanged(String value) {
    setState(() {
      _search = value;
    });
  }

  void _onCharacterTap(Character character) {
    Map<String, TierListItem> updatedCharactersById;

    final itemId = character.itemId;

    final foundItem = _charactersByIds[itemId];
    final item = foundItem ?? TierListItem(id: itemId, value: character);
    final addItem = foundItem == null;

    if (addItem) {
      updatedCharactersById = {
        ..._charactersByIds,
        itemId: item,
      };
    } //
    else {
      updatedCharactersById = {..._charactersByIds} //
        ..remove(itemId);
    }

    setState(() {
      _charactersByIds = updatedCharactersById;
    });

    widget.onCharactersChanged(updatedCharactersById.values.toSet());

    if (addItem) {
      Toast.showItemAddedToast(context, item);
    } //
    else {
      Toast.showItemRemovedToast(context, item);
    }
  }

  void _onAddAnimeCharactersTap(Anime anime, List<Character> characters) {
    final updatedCharactersById = {..._charactersByIds};

    for (final character in characters) {
      final itemId = character.itemId;

      updatedCharactersById.putIfAbsent(
        itemId,
        () => TierListItem(id: itemId, value: character),
      );
    }

    setState(() {
      _charactersByIds = updatedCharactersById;
    });

    widget.onCharactersChanged(updatedCharactersById.values.toSet());
    Toast.showAnimeCharactersAddedToast(context, anime);
  }
}
