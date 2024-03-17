import 'package:anitierlist/src/features/characters/domain/gender.dart';
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

  static CancelFunc showCharacterAddedToast(BuildContext context, String name, Gender gender) {
    return showToast(context, context.loc.characters_characterAdded(name, gender.name));
  }

  static CancelFunc showCharacterRemovedToast(BuildContext context, String name, Gender gender) {
    return showToast(context, context.loc.characters_characterRemoved(name, gender.name));
  }

  static CancelFunc showAnimeCharactersAddedToast(BuildContext context, String title) {
    return showToast(context, context.loc.characters_animeCharactersAdded(title));
  }
}
