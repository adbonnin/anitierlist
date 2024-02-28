import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/characters/presentation/character_search/character_search_tabbar_view.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_list/tierlist_card.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/utils/adaptive_search_dialog.dart';
import 'package:anitierlist/src/widgets/toast.dart';
import 'package:collection/collection.dart';
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
  late Set<Character> _characters;

  Character? _searchCharacter(int id) {
    return _characters.firstWhereOrNull((c) => c.id == id);
  }

  @override
  void initState() {
    super.initState();
    _characters = widget.initialCharacters;
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
    final exists = _searchCharacter(character.id) != null;

    final tierList = TierList(
      id: character.id,
      title: character.name,
      cover: character.image,
    );

    return InkWell(
      onTap: () => _onCharacterTap(character),
      child: Stack(
        children: [
          TierListCard(
            tierList: tierList,
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
    Set<Character> updatedCharacters;

    final foundCharacter = _searchCharacter(character.id);
    final addCharacter = foundCharacter == null;

    if (addCharacter) {
      updatedCharacters = {..._characters, character};
    } //
    else {
      updatedCharacters = {..._characters}..remove(foundCharacter);
    }

    setState(() {
      _characters = updatedCharacters;
    });

    widget.onCharactersChanged(updatedCharacters);

    if (addCharacter) {
      Toast.showCharacterAddedToast(context, character);
    } //
    else {
      Toast.showCharacterRemovedToast(context, character);
    }
  }

  void _onAddAnimeCharactersTap(Anime anime, List<Character> characters) {
    setState(() {
      _characters = {..._characters, ...characters};
    });

    widget.onCharactersChanged(_characters);
    Toast.showAnimeCharactersAddedToast(context, anime);
  }
}
