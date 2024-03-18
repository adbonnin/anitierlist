import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/l10n/app_localization_extension.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

Function() showToast(BuildContext context, String text) {
  final theme = Theme.of(context);

  return BotToast.showText(
    text: text,
    duration: const Duration(seconds: 1),
    textStyle: theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
  );
}

class Toast {
  Toast._();

  static Function() showItemAddedToast(BuildContext context, TierListItem item) {
    final text = context.loc.tierListItemAdded(item);

    if (text.isEmpty) {
      return () {};
    }

    return showToast(context, text);
  }

  static Function() showItemRemovedToast(BuildContext context, TierListItem item) {
    final text = context.loc.tierListItemRemoved(item);

    if (text.isEmpty) {
      return () {};
    }

    return showToast(context, text);
  }

  static Function() showAnimeCharactersAddedToast(BuildContext context, Anime anime) {
    final text = context.loc.characters_animeCharactersAdded(anime.userPreferredTitle);
    return showToast(context, text);
  }
}
