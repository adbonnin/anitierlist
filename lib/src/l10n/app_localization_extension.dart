import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
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

    return value;
  }

  String animeTitle(String title) {
    if (title == AnimeTitle.english) {
      return anime_title_english;
    }

    if (title == AnimeTitle.native) {
      return anime_title_native;
    }

    if (title == AnimeTitle.userPreferred) {
      return anime_title_userPreferred;
    }

    return title;
  }

  String tierListItemRemoved(TierListItem item) {
    final value = item.value;

    if (value is Anime) {
      return anime_animeRemoved(item.title());
    }

    if (value is Character) {
      return characters_characterRemoved(item.title(), value.gender.name);
    }

    return '';
  }

  String tierListItemAdded(TierListItem item) {
    final value = item.value;

    if (value is Anime) {
      return anime_animeAdded(item.title());
    }

    if (value is Character) {
      return characters_characterAdded(item.title(), value.gender.name);
    }

    return '';
  }
}
