import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class TierListValue {
  const TierListValue._();

  String get itemId;

  String? get cover;

  Map<String, String> get titles;
}

class TierListTitle {
  const TierListTitle._();

  static const undefined = '';
  static const custom = 'custom';

  static const alternative = 'alternative';
  static const alternativeSpoiler = 'alternativeSpoiler';
  static const fullName = 'fullName';
  static const native = 'native';
  static const userPreferred = 'userPreferred';
  static const english = 'english';
}

class TierListValueConverter implements JsonConverter<TierListValue, Map<String, dynamic>> {
  static const typeField = 'type';

  static const animeType = 'anime';
  static const characterType = 'character';

  const TierListValueConverter();

  @override
  Map<String, dynamic> toJson(TierListValue object) {
    return switch (object) {
      Anime() => {
          ...object.toJson(),
          typeField: animeType,
        },
      Character() => {
          ...object.toJson(),
          typeField: characterType,
        },
      _ => throw "Type is not supported",
    };
  }

  @override
  TierListValue fromJson(Map<String, dynamic> json) {
    return switch (json[typeField]) {
      animeType => Anime.fromJson(json),
      characterType => Character.fromJson(json),
      _ => throw "Type is not supported",
    };
  }
}
