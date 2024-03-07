import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/characters/presentation/character_search/character_search_tabbar_view.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_item_card.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/utils/adaptive_search_dialog.dart';
import 'package:anitierlist/src/widgets/toast.dart';
import 'package:flutter/material.dart';

void showCharacterAddDialog({
  required BuildContext context,
  Set<Character> initialCharacters = const {},
  required void Function(Set<Character>) onCharactersChanged,
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

  final Set<Character> initialCharacters;
  final void Function(Set<Character> character) onCharactersChanged;

  @override
  State<CharacterAddDialog> createState() => _CharacterAddDialogState();
}

class _CharacterAddDialogState extends State<CharacterAddDialog> {
  var _search = '';
  late Map<int, Character> _charactersByIds;

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
    final exists = _charactersByIds[character.id] != null;

    return InkWell(
      onTap: () => _onCharacterTap(character),
      child: Stack(
        children: [
          TierListItemCard(
            item: character.toItem(),
          ),
          if (exists)
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
    Map<int, Character> updatedCharactersById;

    final foundCharacter = _charactersByIds[character.id];
    final addCharacter = foundCharacter == null;

    if (addCharacter) {
      updatedCharactersById = {
        ..._charactersByIds,
        character.id: character,
      };
    } //
    else {
      updatedCharactersById = {..._charactersByIds} //
        ..remove(character.id);
    }

    setState(() {
      _charactersByIds = updatedCharactersById;
    });

    widget.onCharactersChanged(updatedCharactersById.values.toSet());

    if (addCharacter) {
      Toast.showCharacterAddedToast(context, character);
    } //
    else {
      Toast.showCharacterRemovedToast(context, character);
    }
  }

  void _onAddAnimeCharactersTap(Anime anime, List<Character> characters) {
    final updatedCharactersById = {..._charactersByIds};

    for (final character in characters) {
      updatedCharactersById.putIfAbsent(character.id, () => character);
    }

    setState(() {
      _charactersByIds = updatedCharactersById;
    });

    widget.onCharactersChanged(updatedCharactersById.values.toSet());
    Toast.showAnimeCharactersAddedToast(context, anime);
  }
}
