import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';

class Anime {
  const Anime({
    required this.id,
    this.englishTitle = '',
    this.nativeTitle = '',
    this.userPreferredTitle = '',
    this.customTitle = '',
    this.userSelectedTitle,
    this.coverImage,
    required this.format,
  });

  final int id;
  final String englishTitle;
  final String nativeTitle;
  final String userPreferredTitle;
  final String customTitle;
  final TierListTitle? userSelectedTitle;
  final String? coverImage;
  final AnimeFormat format;

  TierListTitle get selectedTitle {
    if (userSelectedTitle != null) {
      return userSelectedTitle!;
    }

    if (englishTitle.isNotEmpty) {
      return TierListTitle.english;
    }

    if (userPreferredTitle.isNotEmpty) {
      return TierListTitle.userPreferred;
    }

    if (nativeTitle.isNotEmpty) {
      return TierListTitle.native;
    }

    return TierListTitle.english;
  }

  String get title {
    return switch (selectedTitle) {
      TierListTitle.english => englishTitle,
      TierListTitle.native => nativeTitle,
      TierListTitle.userPreferred => userPreferredTitle,
      TierListTitle.custom => customTitle,
      TierListTitle.$unknown => userPreferredTitle,
    };
  }

  Anime copyWith({
    int? id,
    String? englishTitle,
    String? nativeTitle,
    String? userPreferredTitle,
    String? customTitle,
    TierListTitle? userSelectedTitle,
    String? coverImage,
    AnimeFormat? format,
  }) {
    return Anime(
      id: id ?? this.id,
      englishTitle: englishTitle ?? this.englishTitle,
      nativeTitle: nativeTitle ?? this.nativeTitle,
      userPreferredTitle: userPreferredTitle ?? this.userPreferredTitle,
      customTitle: customTitle ?? this.customTitle,
      userSelectedTitle: userSelectedTitle ?? this.userSelectedTitle,
      coverImage: coverImage ?? this.coverImage,
      format: format ?? this.format,
    );
  }

  TierListItem toTierItem() {
    return TierListItem(
      id: 'anime-$id',
      titles: {
        TierListTitle.userPreferred: title,
      },
      group: format.name,
      cover: coverImage,
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
