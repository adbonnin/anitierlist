import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/characters/presentation/character_add/character_add_grid_view.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/utils/adaptive_search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';

void showCharacterAddDialog({
  required BuildContext context,
  required void Function(Character) onCharacterTap,
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
        onCharacterTap: onCharacterTap,
      );
    },
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}

class CharacterAddDialog extends StatefulWidget {
  const CharacterAddDialog({
    super.key,
    required this.onCharacterTap,
  });

  final void Function(Character character) onCharacterTap;

  @override
  State<CharacterAddDialog> createState() => _CharacterAddDialogState();
}

class _CharacterAddDialogState extends State<CharacterAddDialog> {
  final _searchFocusNode = FocusNode();
  var _search = '';

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveSearchDialog(
      title: Text(context.loc.characters_add_title),
      focusNode: _searchFocusNode,
      onChanged: _onChanged,
      content: ScrollShadow(
        child: CharacterAddGridView(
          search: _search,
          onCharacterTap: _onCharacterTap,
        ),
      ),
    );
  }

  void _onChanged(String value) {
    setState(() {
      _search = value;
    });
  }

  void _onCharacterTap(Character character) {
    widget.onCharacterTap(character);
    _searchFocusNode.requestFocus();
  }
}
