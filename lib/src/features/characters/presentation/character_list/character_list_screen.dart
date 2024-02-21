import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/characters/presentation/character_add/character_add_dialog.dart';
import 'package:anitierlist/src/features/tierlist/application/tierlist_service.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_list/tierlist_group_list.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final _groupListKey = GlobalKey<TierListGroupListState>();

  var _tierLists = <TierList>{};
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return TierListGroupList(
      key: _groupListKey,
      tierLists: _tierLists,
      otherActions: [
        IconButton(
          onPressed: _onAddCharacterPressed,
          icon: const Icon(Icons.person_add),
          tooltip: context.loc.characters_add_title,
        )
      ],
      isLoading: _loading,
      onTierListTap: _onDeleteTierListTap,
      onExportPressed: _onExportPressed,
      onSharePressed: _onSharePressed,
    );
  }

  void _onAddCharacterPressed() {
    showCharacterAddDialog(
      context: context,
      onCharacterTap: _onAddCharacterTap,
    );
  }

  void _onAddCharacterTap(Character character) {
    final tierList = TierList(
      id: character.id,
      title: character.name,
      cover: character.image,
    );

    setState(() {
      _tierLists = {..._tierLists, tierList};
    });
  }

  void _onDeleteTierListTap(TierList tierList) {
    setState(() {
      _tierLists = {..._tierLists}..remove(tierList);
    });
  }

  Future<void> _onExportPressed() async {
    final tierListScreenshotsByFormat = _groupListKey.currentState?.buildTierListScreenshotsByFormat() ?? {};
    final name = context.loc.characters_title;

    setState(() {
      _loading = true;
    });

    try {
      final bytes = await TierListService.buildZip(tierListScreenshotsByFormat);
      await TierListService.saveZipFile(name, bytes);
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
