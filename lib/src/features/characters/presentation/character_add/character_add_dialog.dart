import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/characters/presentation/character_add/character_add_page.dart';
import 'package:anitierlist/src/features/tierlist/application/tierlist_providers.dart';
import 'package:anitierlist/src/features/tierlist/application/tierlist_service.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/widgets/async_value_widget.dart';
import 'package:anitierlist/src/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showCharacterAddDialog({
  required BuildContext context,
  required String tierListId,
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
        tierListId: tierListId,
      );
    },
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}

class CharacterAddDialog extends ConsumerStatefulWidget {
  const CharacterAddDialog({
    super.key,
    required this.tierListId,
  });

  final String tierListId;

  @override
  ConsumerState<CharacterAddDialog> createState() => _CharacterAddDialogState();
}

class _CharacterAddDialogState extends ConsumerState<CharacterAddDialog> {
  @override
  Widget build(BuildContext context) {
    final characterProvider = tierListItemsSnapshotsProvider(widget.tierListId);

    final charactersSnapshot = ref.watch(characterProvider);
    ref.listen(characterProvider, _handleItems);

    return AsyncValueWidget(
      charactersSnapshot,
      data: (characters) => CharacterAddPage(
        characters: characters,
        onAddCharacterTap: _onAddCharacterTap,
        onRemoveCharacterTap: _onRemoveCharacterTap,
        onAddAnimeCharactersTap: _onAddAnimeCharactersTap,
      ),
    );
  }

  Future<void> _onAddCharacterTap(TierListItem character) async {
    final service = ref.read(tierListServiceProvider);
    await service.addItem(widget.tierListId, character);
  }

  Future<void> _onRemoveCharacterTap(TierListItem character) {
    final service = ref.read(tierListServiceProvider);
    return service.removeItem(widget.tierListId, character.id);
  }

  Future<void> _onAddAnimeCharactersTap(Anime anime, Iterable<TierListItem> characters) {
    final service = ref.read(tierListServiceProvider);
    return service.addAllItems(widget.tierListId, characters);
  }

  void _handleItems(AsyncValue<Iterable<TierListItem>>? previous, AsyncValue<Iterable<TierListItem>> next) {
    final messages = TierListService.notifyTierListItem(context.loc, previous, next);

    for (final message in messages) {
      if (mounted) {
        showToast(context, message);
      }
    }
  }
}
