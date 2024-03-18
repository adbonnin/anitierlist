import 'package:anitierlist/src/features/characters/domain/gender.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist_value.dart';
import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable()
class Character implements TierListValue {
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

  @override
  String get itemId {
    return 'character-$id';
  }

  @override
  String? get cover {
    return image;
  }

  @override
  Map<String, String> get titles {
    return {
      TierListTitle.alternative: alternativeName,
      TierListTitle.alternativeSpoiler: alternativeSpoilerName,
      TierListTitle.fullName: fullName,
      TierListTitle.native: nativeName,
      TierListTitle.userPreferred: userPreferredName,
    };
  }

  factory Character.fromJson(Map<String, Object?> json) => //
      _$CharacterFromJson(json);

  Map<String, Object?> toJson() => //
      _$CharacterToJson(this);
}
