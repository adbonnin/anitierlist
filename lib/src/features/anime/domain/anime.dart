import 'package:anitierlist/src/features/tierlist/domain/tierlist_value.dart';
import 'package:json_annotation/json_annotation.dart';

part 'anime.g.dart';

@JsonSerializable()
class Anime implements TierListValue {
  const Anime({
    required this.id,
    this.englishTitle = '',
    this.nativeTitle = '',
    this.userPreferredTitle = '',
    this.coverImage,
    required this.format,
  });

  final int id;
  final String englishTitle;
  final String nativeTitle;
  final String userPreferredTitle;
  final String? coverImage;
  final AnimeFormat format;

  @override
  String get itemId {
    return 'anime-$id';
  }

  @override
  String? get cover {
    return coverImage;
  }

  @override
  Map<String, String> get titles {
    return {
      TierListTitle.userPreferred: userPreferredTitle,
      TierListTitle.english: englishTitle,
      TierListTitle.native: nativeTitle,
    }.removeEmptyTitles();
  }

  factory Anime.fromJson(Map<String, Object?> json) => //
      _$AnimeFromJson(json);

  Map<String, Object?> toJson() => //
      _$AnimeToJson(this);

  Anime copyWith({
    int? id,
    String? englishTitle,
    String? nativeTitle,
    String? userPreferredTitle,
    String? customTitle,
    String? coverImage,
    AnimeFormat? format,
  }) {
    return Anime(
      id: id ?? this.id,
      englishTitle: englishTitle ?? this.englishTitle,
      nativeTitle: nativeTitle ?? this.nativeTitle,
      userPreferredTitle: userPreferredTitle ?? this.userPreferredTitle,
      coverImage: coverImage ?? this.coverImage,
      format: format ?? this.format,
    );
  }
}

enum AnimeFormat {
  tv,
  tvShort,
  leftover,
  movie,
  ovaOnaSpecial,
}

extension AnimeIterableExtension on Iterable<Anime> {
  Iterable<Anime> whereTv() {
    return whereFormat(AnimeFormat.tv);
  }

  Iterable<Anime> whereTvShort() {
    return whereFormat(AnimeFormat.tvShort);
  }

  Iterable<Anime> whereMovie() {
    return whereFormat(AnimeFormat.movie);
  }

  Iterable<Anime> whereOvaOnaSpecial() {
    return whereFormat(AnimeFormat.ovaOnaSpecial);
  }

  Iterable<Anime> whereFormat(AnimeFormat format) {
    return where((a) => a.format == format);
  }
}
