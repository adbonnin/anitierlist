import 'package:anitierlist/src/features/anilist/application/anilist_service.dart';
import 'package:anitierlist/src/features/anilist/data/browse_characters.graphql.dart';
import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/utils/graphql.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'character_service.g.dart';

@Riverpod(keepAlive: true)
CharacterService characterService(CharacterServiceRef ref) {
  final anilistService = ref.watch(anilistServiceProvider);
  return CharacterService(anilistService);
}

class CharacterService {
  const CharacterService(this.anilistService);

  final AnilistService anilistService;

  Future<PagedResult<List<Character>>> browseCharacters(String? search, int page) async {
    final result = await anilistService.browseCharacters(
      search: search,
      page: page,
      perPage: 12,
    );

    final p = result.parsedData?.Page;

    final characters = (p?.characters ?? []) //
        .whereNotNull()
        .map((c) => c.toCharacter())
        .toList();

    final hasNextPage = (p?.pageInfo?.hasNextPage ?? false) && characters.isNotEmpty;

    return PagedResult(
      value: characters,
      hasNextPage: hasNextPage,
    );
  }
}

extension _CharacterExtension on Query$BrowseCharacters$Page$characters {
  Character toCharacter() {
    return Character(
      id: id,
      name: name?.userPreferred ?? '',
      image: image?.medium,
    );
  }
}