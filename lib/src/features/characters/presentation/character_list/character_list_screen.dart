import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/characters/presentation/character_add/character_add_dialog.dart';
import 'package:anitierlist/src/features/tierlist/application/tierlist_service.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_list/tierlist_group_list.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/utils/file.dart';
import 'package:anitierlist/src/utils/string_extension.dart';
import 'package:anitierlist/src/widgets/toast.dart';
import 'package:anitierlist/styles.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final _groupListKey = GlobalKey<TierListGroupListState>();

  var _characters = <Character>{};
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return TierListGroupList(
      key: _groupListKey,
      items: _characters.map((c) => c.toItem()),
      otherActions: [
        IconButton(
          onPressed: _onAddCharacterPressed,
          icon: const Icon(Icons.person_add),
          tooltip: context.loc.characters_add_title,
        )
      ],
      emptyBuilder: _buildEmpty,
      isLoading: _loading,
      onItemTap: _onDeleteTierListTap,
      onExportPressed: _onExportPressed,
      onSharePressed: _onSharePressed,
    );
  }

  void _onAddCharacterPressed() {
    showCharacterAddDialog(
      context: context,
      initialCharacters: _characters,
      onCharactersChanged: _onCharactersChanged,
    );
  }

  void _onCharactersChanged(Set<Character> characters) {
    setState(() {
      _characters = characters;
    });
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.loc.characters_emptyList),
          Gaps.p18,
          TextButton.icon(
            onPressed: _onAddCharacterPressed,
            icon: const Icon(Icons.person_add),
            label: Text(context.loc.characters_add_title),
          )
        ],
      ),
    );
  }

  void _onDeleteTierListTap(TierListItem item) {
    final character = _characters.firstWhereOrNull((c) => c.id == item.id);

    if (character == null) {
      return;
    }

    setState(() {
      _characters = {..._characters} //
        ..remove(character);
    });

    Toast.showCharacterRemovedToast(context, character);
  }

  Future<void> _onExportPressed() async {
    final tierListScreenshotsByFormat = _groupListKey.currentState?.buildTierListScreenshotsByFormat() ?? {};
    final name = context.loc.characters_exportName(DateTime.now()).replaceSpecialCharacters('-');

    setState(() {
      _loading = true;
    });

    try {
      final bytes = await TierListService.buildZip(tierListScreenshotsByFormat);
      await saveZipFile(name, bytes);
    } //
    finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _onSharePressed() async {
    final tierListScreenshotsByFormat = _groupListKey.currentState?.buildTierListScreenshotsByFormat() ?? {};
    final name = context.loc.characters_title;

    setState(() {
      _loading = true;
    });

    try {
      final bytes = await TierListService.buildZip(tierListScreenshotsByFormat);
      await TierListService.share(name, bytes);
    } //
    finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
