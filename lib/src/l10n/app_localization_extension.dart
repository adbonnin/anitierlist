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

  String animeGroup(String value) {
    if (value == AnimeFormat.tv.name) {
      return anime_tierlist_tv;
    }

    if (value == AnimeFormat.tvShort.name) {
      return anime_tierlist_tvShort;
    }

    if (value == AnimeFormat.leftover.name) {
      return anime_tierlist_leftover;
    }

    if (value == AnimeFormat.movie.name) {
      return anime_tierlist_movie;
    }

    if (value == AnimeFormat.ovaOnaSpecial.name) {
      return anime_tierlist_ovaOnaSpecial;
    }

    return '';
  }
}
