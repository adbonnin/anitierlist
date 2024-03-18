import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist_value.dart';
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
    return switch (title) {
      TierListTitle.undefined => tierlist_undefinedTitle,
      TierListTitle.custom => tierlist_customTitle,
      TierListTitle.alternative => tierlist_alternativeTitle,
      TierListTitle.alternativeSpoiler => tierlist_alternativeSpoilerTitle,
      TierListTitle.fullName => tierlist_fullNameTitle,
      TierListTitle.native => tierlist_nativeTitle,
      TierListTitle.userPreferred => tierlist_userPreferredTitle,
      TierListTitle.english => tierlist_englishTitle,
      _ => title,
    };
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
