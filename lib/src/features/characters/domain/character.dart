import 'package:anitierlist/src/features/characters/domain/gender.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/utils/iterable_extensions.dart';

class Character {
  const Character({
    required this.id,
    required this.alternativeName,
    required this.alternativeSpoilerName,
    required this.fullName,
    required this.nativeName,
    required this.userPreferredName,
    required this.image,
    required this.gender,
  });

  final int id;
  final String alternativeName;
  final String alternativeSpoilerName;
  final String fullName;
  final String nativeName;
  final String userPreferredName;
  final String? image;
  final Gender gender;

  TierListItem toItem() {
    return TierListItem(
      id: 'character-$id',
      titles: {
        TierListTitle.userPreferred: userPreferredName,
      },
      cover: image,
    );
  }
}

extension CharacterIterableExtension on Iterable<Character> {
  Map<int, Character> toMapById() {
    return map((e) => (e.id, e)).toMap();
  }
}
