import 'package:anitierlist/src/features/anime/application/anime_providers.dart';
import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/tierlist/application/tierlist_service.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/utils/iterable_extensions.dart';
import 'package:anitierlist/src/utils/season.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tierlist_providers.g.dart';

@riverpod
Stream<List<TierList>> tierListsSnapshots(
  TierListsSnapshotsRef ref,
) {
  final service = ref.watch(tierListServiceProvider);
  return service.tierLists();
}

@riverpod
Stream<List<TierListItem>> tierListItemsSnapshots(
  TierListItemsSnapshotsRef ref,
  String tierListId,
) {
  final service = ref.watch(tierListServiceProvider);
  return service.tierListItems(tierListId);
}

@riverpod
AsyncValue<Iterable<TierListItem>> browseTierListAnimeSeason(
  BrowseTierListAnimeSeasonRef ref,
  int year,
  Season season,
) {
  final asyncBrowseAnimeSeason = ref.watch(browseAnimeSeasonProvider(year, season));

  TierListItem toItem(Anime anime) {
    return TierListItem(
      id: anime.itemId,
      group: anime.format.name,
      value: anime,
    );
  }

  return asyncBrowseAnimeSeason.whenData((anime) => anime //
      .stableSorted((a, b) => a.format.index - b.format.index)
      .map(toItem));
}
