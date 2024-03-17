import 'package:anitierlist/src/features/anilist/application/anilist_service.dart';
import 'package:anitierlist/src/features/anilist/data/fragments.graphql.dart';
import 'package:anitierlist/src/features/anilist/data/schema.graphql.dart';
import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/utils/anime.dart';
import 'package:anitierlist/src/utils/graphql.dart';
import 'package:anitierlist/src/utils/iterable_extensions.dart';
import 'package:anitierlist/src/utils/riverpod.dart';
import 'package:anitierlist/src/utils/season.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'anime_service.g.dart';

@Riverpod(keepAlive: true)
AnimeService animeService(AnimeServiceRef ref) {
  final anilistService = ref.read(anilistServiceProvider);

  return AnimeService(
    anilistService: anilistService,
  );
}

class AnimeService {
  const AnimeService({
    required this.anilistService,
  });

  final AnilistService anilistService;

  Future<Iterable<Anime>> browseLeftovers({
    required int year,
    required Season season,
  }) async {
    final anime = await browseAnime(
      year: season.previousAnimeYear(year),
      season: season.previous,
      episodeGreater: 16,
    );

    Anime copyWithLeftover(Anime anime) {
      return anime.copyWith(
        format: anime.format != AnimeFormat.ovaOnaSpecial //
            ? AnimeFormat.leftover
            : anime.format,
      );
    }

    return anime.map(copyWithLeftover);
  }

  Future<Iterable<Anime>> browseAnime({
    required int year,
    required Season season,
    int? episodeGreater,
  }) {
    return PagedResult.queryIterables(
      (page) => _searchPagedAnime(
        page: page,
        year: year,
        season: season,
        episodeGreater: episodeGreater,
      ),
    );
  }

  Future<PagedResult<List<Anime>>> searchPagedAnime({
    required String? search,
    required int page,
  }) {
    return _searchPagedAnime(
      search: search,
      page: page,
    );
  }

  Future<PagedResult<List<Anime>>> _searchPagedAnime({
    required int page,
    int? perPage,
    String? search,
    int? year,
    Season? season,
    int? episodeGreater,
  }) async {
    final result = await anilistService.searchAnime(
      page: page,
      perPage: perPage,
      search: search,
      year: year,
      season: season,
      episodeGreater: episodeGreater,
    );

    final p = result.parsedData?.Page;
    final anime = (p?.media ?? []).map((c) => c?.toAnime());
    final hasNextPage = (p?.pageInfo?.hasNextPage ?? false) && anime.isNotEmpty;

    return PagedResult(
      value: anime.whereNotNull().toList(),
      hasNextPage: hasNextPage,
    );
  }
}

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

extension _MediaExtension on Fragment$SimpleMedia {
  Anime? toAnime() {
    final animeFormat = format?.toMediaFormat();

    if (animeFormat == null) {
      return null;
    }

    return Anime(
      id: id,
      englishTitle: title?.english ?? '',
      nativeTitle: title?.native ?? '',
      userPreferredTitle: title?.userPreferred ?? '',
      coverImage: coverImage?.medium,
      format: animeFormat,
    );
  }
}

extension _Enum$MediaFormatExtension on Enum$MediaFormat {
  AnimeFormat? toMediaFormat() {
    return switch (this) {
      Enum$MediaFormat.MOVIE => AnimeFormat.movie,
      Enum$MediaFormat.ONA => AnimeFormat.ovaOnaSpecial,
      Enum$MediaFormat.OVA => AnimeFormat.ovaOnaSpecial,
      Enum$MediaFormat.SPECIAL => AnimeFormat.ovaOnaSpecial,
      Enum$MediaFormat.TV => AnimeFormat.tv,
      Enum$MediaFormat.TV_SHORT => AnimeFormat.tvShort,
      _ => null,
    };
  }
}
