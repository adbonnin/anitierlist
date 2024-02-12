import 'package:anitierlist/src/features/anilist/application/anilist_service.dart';
import 'package:anitierlist/src/features/anilist/data/browse_anime.graphql.dart';
import 'package:anitierlist/src/features/anilist/data/schema.graphql.dart';
import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/utils/iterable_extensions.dart';
import 'package:anitierlist/src/utils/season.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'anime_service.g.dart';

@Riverpod(keepAlive: true)
AnimeService animeService(AnimeServiceRef ref) {
  return AnimeService(ref);
}

class AnimeService {
  const AnimeService(this.ref);

  final Ref ref;

  Future<List<Anime>> browseAnime(int year, Season season) async {
    final anilistService = ref.read(anilistServiceProvider);

    final anime = (await anilistService.browseAnime(year: year, season: season)) //
        .map((m) => m.toAnime())
        .whereNotNull();

    final leftovers = (await anilistService.browseLeftovers(year: year, season: season)) //
        .map((m) => m.toAnime(leftover: true))
        .whereNotNull();

    return [anime, leftovers] //
        .flatten()
        .sorted((a, b) => a.format.toIndex() - b.format.toIndex())
        .toList();
  }
}

@riverpod
Future<List<Anime>> browseAnime(BrowseAnimeRef ref, int year, Season season) {
  final service = ref.read(animeServiceProvider);
  return service.browseAnime(year, season);
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
