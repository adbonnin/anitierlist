import 'package:anitierlist/src/features/anilist/data/browse_anime_characters.graphql.dart';
import 'package:anitierlist/src/features/anilist/data/schema.graphql.dart';
import 'package:anitierlist/src/features/anilist/data/search_anime.graphql.dart';
import 'package:anitierlist/src/features/anilist/data/search_characters.graphql.dart';
import 'package:anitierlist/src/utils/season.dart';
import 'package:graphql/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'anilist_service.g.dart';

@Riverpod(keepAlive: true)
AnilistService anilistService(AnilistServiceRef ref) {
  final client = GraphQLClient(
    link: HttpLink('https://graphql.anilist.co'),
    cache: GraphQLCache(),
  );

  return AnilistService(client);
}

class AnilistService {
  const AnilistService(this.client);

  final GraphQLClient client;

  Future<QueryResult<Query$SearchAnime>> searchAnime({
    int? page,
    String? search,
    int? year,
    Season? season,
    int? episodeGreater,
  }) {
    return client.query$SearchAnime(
      Options$Query$SearchAnime(
        variables: Variables$Query$SearchAnime(
          page: page,
          search: search,
          seasonYear: year,
          season: season?.toEnum$MediaSeason(),
          episodeGreater: episodeGreater,
        ),
      ),
    );
  }

  Future<QueryResult<Query$SearchCharacters>> searchCharacters({
    int? page,
    int? perPage,
    String? search,
  }) {
    return client.query$SearchCharacters(
      Options$Query$SearchCharacters(
        variables: Variables$Query$SearchCharacters(
          page: page,
          perPage: perPage,
          search: (search?.trim().isEmpty ?? true) ? null : search,
        ),
      ),
    );
  }

  Future<QueryResult<Query$BrowseAnimeCharacters>> browseAnimeCharacters(
    int? page,
    int? id,
  ) {
    return client.query$BrowseAnimeCharacters(
      Options$Query$BrowseAnimeCharacters(
        variables: Variables$Query$BrowseAnimeCharacters(
          page: page,
          id: id,
        ),
      ),
    );
  }
}

extension _SeasonExtension on Season {
  Enum$MediaSeason toEnum$MediaSeason() {
    return switch (this) {
      Season.winter => Enum$MediaSeason.WINTER,
      Season.spring => Enum$MediaSeason.SPRING,
      Season.summer => Enum$MediaSeason.SUMMER,
      Season.fall => Enum$MediaSeason.FALL,
    };
  }
}
