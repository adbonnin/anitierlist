import 'package:anitierlist/src/features/characters/domain/gender.dart';
import 'package:anitierlist/src/features/tierlist/domain/tier_item.dart';
import 'package:anitierlist/src/utils/iterable_extensions.dart';

class Character {
  const Character({
    required this.id,
    required this.name,
    required this.image,
    required this.gender,
  });

  final int id;
  final String name;
  final String? image;
  final Gender gender;

  TierItem toTierItem() {
    return TierItem(
      id: id,
      title: name,
      cover: image,
    );
  }
}

extension CharacterIterableExtension on Iterable<Character> {
  Map<int, Character> toMapById() {
    return map((e) => (e.id, e)).toMap();
  }
}