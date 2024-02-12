import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/utils/season.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocalizationsExtension on AppLocalizations {
  String season(Season value) {
    return switch (value) {
      Season.spring => common_spring,
      Season.summer => common_summer,
      Season.fall => common_fall,
      Season.winter => common_winter,
    };
  }

  String animeFormat(AnimeFormat value) {
    return switch (value) {
      AnimeFormat.tv => anime_tierlist_tv,
      AnimeFormat.tvShort => anime_tierlist_tvShort,
      AnimeFormat.leftover => anime_tierlist_leftover,
      AnimeFormat.movie => anime_tierlist_movie,
      AnimeFormat.ovaOnaSpecial => anime_tierlist_ovaOnaSpecial,
    };
  }
}
