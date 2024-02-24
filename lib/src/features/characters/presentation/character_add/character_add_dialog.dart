import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/characters/presentation/character_add/character_add_grid_view.dart';
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
      content: CharacterAddGridView(
        search: _search,
        characters: _characters,
        onCharacterTap: _onCharacterTap,
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

    final foundCharacter = _characters.firstWhereOrNull((c) => c.id == character.id);

    if (foundCharacter != null) {
      updatedCharacters = {..._characters}..remove(foundCharacter);
      Toast.showCharacterRemovedToast(context, character);
    } //
    else {
      updatedCharacters = {..._characters, character};
      Toast.showCharacterAddedToast(context, character);
    }

    setState(() {
      _characters = updatedCharacters;
    });

    widget.onCharactersChanged(_characters);
  }
}
