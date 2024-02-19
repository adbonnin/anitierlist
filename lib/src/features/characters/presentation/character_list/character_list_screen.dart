import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/characters/presentation/character_add/character_add_dialog.dart';
import 'package:anitierlist/src/features/tierlist/application/tierlist_service.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_list/tierlist_group_list.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final _groupListKey = GlobalKey<TierListGroupListState>();

  var _tierLists = <TierList>{};
  var _exporting = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: _onAddCharacterPressed,
              icon: const Icon(Icons.person_add),
              label: Text(context.loc.characters_add_title),
            ),
          ],
        ),
        Gaps.p8,
        Expanded(
          child: TierListGroupList(
            key: _groupListKey,
            tierLists: _tierLists,
            exporting: _exporting,
            onTierListTap: (_) {},
            onExportPressed: _onExportPressed,
          ),
        ),
      ],
    );
  }

  void _onAddCharacterPressed() {
    showCharacterAddDialog(
      context: context,
      onCharacterTap: _onAddCharacter,
    );
  }

  void _onAddCharacter(Character character) {
    final tierList = TierList(
      id: character.id,
      title: character.name,
      cover: character.image,
    );

    setState(() {
      _tierLists = {..._tierLists, tierList};
    });
  }

  Future<void> _onExportPressed() async {
    final tierListScreenshotsByFormat = _groupListKey.currentState?.buildTierListScreenshotsByFormat() ?? {};
    final name = context.loc.characters_title;

    setState(() {
      _exporting = true;
    });

    try {
      final bytes = await TierListService.buildZip(tierListScreenshotsByFormat);
      await TierListService.saveZipFile(name, bytes);
    } //
    finally {
      setState(() {
        _exporting = false;
      });
    }
  }
}
