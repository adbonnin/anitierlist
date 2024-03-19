import 'package:anitierlist/src/features/anime/application/anime_service.dart';
import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/utils/iterable_extensions.dart';
import 'package:anitierlist/src/utils/riverpod.dart';
import 'package:anitierlist/src/utils/season.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'anime_providers.g.dart';

@riverpod
Future<Iterable<Anime>> browseLeftovers(
  BrowseLeftoversRef ref, {
  required int year,
  required Season season,
}) {
  final service = ref.watch(animeServiceProvider);

  return service.browseLeftovers(
    year: year,
    season: season,
  );
}

@riverpod
Future<Iterable<Anime>> browseAnime(
  BrowseAnimeRef ref, {
  required int year,
  required Season season,
}) {
  final service = ref.watch(animeServiceProvider);

  return service.browseAnime(
    year: year,
    season: season,
  );
}

@riverpod
AsyncValue<Iterable<Anime>> browseAnimeSeason(BrowseAnimeSeasonRef ref, int year, Season season) {
  final asyncAnime = ref.watch(browseAnimeProvider(
    year: year,
    season: season,
  ));

  final asyncLeftovers = ref.watch(browseLeftoversProvider(
    year: year,
    season: season,
  ));

  return AsyncValues.group2(asyncAnime, asyncLeftovers) //
      .whenData((value) => [value.$1, value.$2].flatten());
}
