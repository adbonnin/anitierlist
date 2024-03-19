import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/characters/presentation/character_add/character_add_page.dart';
import 'package:anitierlist/src/features/tierlist/application/tierlist_providers.dart';
import 'package:anitierlist/src/features/tierlist/application/tierlist_service.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
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
    final charactersSnapshot = ref.watch(tierListItemsSnapshotProvider(widget.tierListId));

    return AsyncValueWidget(
      charactersSnapshot,
      data: (characters) => CharacterAddPage(
        characters: characters,
        onAddCharacterTap: _onAddCharacterTap,
        onDeleteCharacterTap: _onDeleteCharacterTap,
        onAddAnimeCharactersTap: _onAddAnimeCharactersTap,
      ),
    );
  }

  Future<void> _onAddCharacterTap(TierListItem character) async {
    final service = ref.read(tierListServiceProvider);
    await service.addItem(widget.tierListId, character);

    if (mounted) {
      Toast.showItemAddedToast(context, character);
    }
  }

  Future<void> _onDeleteCharacterTap(TierListItem character) async {
    final service = ref.read(tierListServiceProvider);
    await service.removeItem(widget.tierListId, character.id);

    if (mounted) {
      Toast.showItemRemovedToast(context, character);
    }
  }

  Future<void> _onAddAnimeCharactersTap(Anime anime, Iterable<TierListItem> characters) async {
    final service = ref.read(tierListServiceProvider);
    await service.addAllItems(widget.tierListId, characters);

    if (mounted) {
      Toast.showAnimeCharactersAddedToast(context, anime);
    }
  }
}
