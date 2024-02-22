import 'package:anitierlist/src/features/anilist/application/anilist_service.dart';
import 'package:anitierlist/src/features/anilist/data/browse_anime.graphql.dart';
import 'package:anitierlist/src/features/anilist/data/schema.graphql.dart';
import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/utils/iterable_extensions.dart';
import 'package:anitierlist/src/utils/riverpod.dart';
import 'package:anitierlist/src/utils/season.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'anime_service.g.dart';

@riverpod
AsyncValue<Iterable<Anime>> browseAnimeSeason(BrowseAnimeSeasonRef ref, int year, Season season) {
  final asyncAnime = ref
      .watch(browseAnimeProvider(
        year: year,
        season: season,
      ))
      .whenData((value) => value.map((m) => m.toAnime()));

  final asyncLeftovers = ref
      .watch(browseLeftoversProvider(
        year: year,
        season: season,
      ))
      .whenData((value) => value.map((m) => m.toAnime(leftover: true)));

  return AsyncValues.group2(asyncAnime, asyncLeftovers) //
      .whenData((value) => [value.$1, value.$2].flatten().whereNotNull());
}

extension _MediaExtension on Query$BrowseAnime$Page$media {
  Anime? toAnime({bool leftover = false}) {
    final animeFormat = format?.toMediaFormat();

    if (animeFormat == null) {
      return null;
    }

    return Anime(
      id: id,
      englishTitle: title?.english ?? '',
      nativeTitle: title?.native ?? '',
      userPreferredTitle: title?.userPreferred ?? '',
      coverImageMedium: coverImage?.medium,
      format: leftover && animeFormat != AnimeFormat.ovaOnaSpecial ? AnimeFormat.leftover : animeFormat,
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
