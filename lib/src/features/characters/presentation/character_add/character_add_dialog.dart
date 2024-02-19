import 'package:anitierlist/src/features/anilist/data/browse_characters.graphql.dart';
import 'package:anitierlist/src/features/characters/presentation/character_add/character_add_grid_view.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';

void showCharacterAddDialog({
  required BuildContext context,
  required void Function(Query$BrowseCharacters$Page$characters) onCharacterTap,
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

  final void Function(Query$BrowseCharacters$Page$characters character) onCharacterTap;

  @override
  State<CharacterAddDialog> createState() => _CharacterAddDialogState();
}

class _CharacterAddDialogState extends State<CharacterAddDialog> {
  final _searchFocusNode = FocusNode();
  final _searchController = TextEditingController();

  var _search = '';

  @override
  void initState() {
    super.initState();

    _searchFocusNode.requestFocus();
    _searchController.addListener(_handleChange);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.loc.characters_add_title),
      content: SizedBox(
        width: Sizes.dialogMinWidth,
        height: Sizes.dialogMinHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              focusNode: _searchFocusNode,
              controller: _searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Gaps.p8,
            Expanded(
              child: ScrollShadow(
                child: CharacterAddGridView(
                  search: _search,
                  onCharacterTap: widget.onCharacterTap,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: _onClosePressed,
          child: Text(context.loc.common_close),
        ),
      ],
    );
  }

  void _handleChange() {
    setState(() {
      _search = _searchController.text.trim();
    });
  }

  void _onClosePressed() {
    Navigator.pop(context);
  }
}
