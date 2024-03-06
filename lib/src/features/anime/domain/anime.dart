import 'package:anitierlist/src/features/tierlist/domain/tier_item.dart';

class Anime {
  const Anime({
    required this.id,
    this.englishTitle = '',
    this.nativeTitle = '',
    this.userPreferredTitle = '',
    this.customTitle = '',
    this.userSelectedTitle,
    this.coverImageMedium,
    required this.format,
  });

  final int id;
  final String englishTitle;
  final String nativeTitle;
  final String userPreferredTitle;
  final String customTitle;
  final MediaTitle? userSelectedTitle;
  final String? coverImageMedium;
  final AnimeFormat format;

  MediaTitle get selectedTitle {
    if (userSelectedTitle != null) {
      return userSelectedTitle!;
    }

    if (englishTitle.isNotEmpty) {
      return MediaTitle.english;
    }

    if (userPreferredTitle.isNotEmpty) {
      return MediaTitle.userPreferred;
    }

    if (nativeTitle.isNotEmpty) {
      return MediaTitle.native;
    }

    return MediaTitle.english;
  }

  String get title {
    return switch (selectedTitle) {
      MediaTitle.english => englishTitle,
      MediaTitle.native => nativeTitle,
      MediaTitle.userPreferred => userPreferredTitle,
      MediaTitle.custom => customTitle,
    };
  }

  Anime copyWith({
    int? id,
    String? englishTitle,
    String? nativeTitle,
    String? userPreferredTitle,
    String? customTitle,
    MediaTitle? userSelectedTitle,
    String? coverImageMedium,
    AnimeFormat? format,
  }) {
    return Anime(
      id: id ?? this.id,
      englishTitle: englishTitle ?? this.englishTitle,
      nativeTitle: nativeTitle ?? this.nativeTitle,
      userPreferredTitle: userPreferredTitle ?? this.userPreferredTitle,
      customTitle: customTitle ?? this.customTitle,
      userSelectedTitle: userSelectedTitle ?? this.userSelectedTitle,
      coverImageMedium: coverImageMedium ?? this.coverImageMedium,
      format: format ?? this.format,
    );
  }

  TierItem toTierItem() {
    return TierItem(
      id: id,
      title: title,
      group: format.name,
      cover: coverImageMedium,
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

enum MediaTitle {
  english,
  native,
  userPreferred,
  custom,
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
