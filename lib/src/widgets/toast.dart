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
