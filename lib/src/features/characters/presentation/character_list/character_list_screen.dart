import 'package:anitierlist/src/features/characters/presentation/character_add/character_add_dialog.dart';
import 'package:anitierlist/src/features/tierlist/application/tierlist_providers.dart';
import 'package:anitierlist/src/features/tierlist/application/tierlist_service.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_list/tierlist_group_list.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/utils/file.dart';
import 'package:anitierlist/src/utils/string_extension.dart';
import 'package:anitierlist/src/widgets/async_value_widget.dart';
import 'package:anitierlist/src/widgets/toast.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterListScreen extends ConsumerStatefulWidget {
  const CharacterListScreen({super.key});

  final String tierListId = 'CaCs3LKLX6lHcFF4jxG3';

  @override
  ConsumerState<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends ConsumerState<CharacterListScreen> {
  final _groupListKey = GlobalKey<TierListGroupListState>();

  var _loading = false;

  @override
  Widget build(BuildContext context) {
    final asyncCharacters = ref.watch(tierListItemsSnapshotProvider(widget.tierListId));

    return AsyncValueWidget(
      asyncCharacters,
      data: (characters) => TierListGroupList(
        key: _groupListKey,
        items: characters,
        otherActions: [
          IconButton(
            onPressed: _onAddCharacterPressed,
            icon: const Icon(Icons.person_add),
            tooltip: context.loc.characters_add_title,
          )
        ],
        emptyBuilder: _buildEmpty,
        isLoading: _loading,
        onItemTap: _onDeleteItemTap,
        onExportPressed: _onExportPressed,
        onSharePressed: _onSharePressed,
      ),
    );
  }

  void _onAddCharacterPressed() {
    showCharacterAddDialog(
      context: context,
      tierListId: widget.tierListId,
    );
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

  Future<void> _onDeleteItemTap(TierListItem item) async {
    final service = ref.read(tierListServiceProvider);

    await service.removeItem(widget.tierListId, item.id);

    if (mounted) {
      Toast.showItemRemovedToast(context, item);
    }
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
      await shareZipFile(name, bytes);
    } //
    finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
