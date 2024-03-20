import 'package:anitierlist/src/features/anime/presentation/anime_edit/anime_edit_form.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';

Future<AnimeEditDialogData?> showAnimeEditDialog({
  required BuildContext context,
  required TierListItem anime,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  return showDialog<AnimeEditDialogData>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    builder: (_) => AnimeEditDialog(
      anime: anime,
    ),
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}

class AnimeEditDialogData {
  const AnimeEditDialogData({
    required this.selectedTitle,
    required this.customTitle,
  });

  final String selectedTitle;
  final String customTitle;
}

class AnimeEditDialog extends StatefulWidget {
  const AnimeEditDialog({
    super.key,
    required this.anime,
  });

  final TierListItem anime;

  @override
  State<AnimeEditDialog> createState() => _AnimeEditDialogState();
}

class _AnimeEditDialogState extends State<AnimeEditDialog> {
  final _formKey = GlobalKey<AnimeEditFormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.loc.anime_tierlist_edit_title),
      content: SizedBox(
        width: Sizes.dialogMinWidth,
        child: AnimeEditForm(
          key: _formKey,
          anime: widget.anime,
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: _onCancelPressed,
          child: Text(context.loc.common_cancel),
        ),
        OutlinedButton(
          onPressed: _onCancelPressed,
          child: Text(context.loc.common_delete),
        ),
        FilledButton(
          onPressed: _onConfirmPressed,
          child: Text(context.loc.common_confirm),
        ),
      ],
    );
  }

  void _onCancelPressed() {
    Navigator.of(context).pop();
  }

  void _onConfirmPressed() {
    final formState = _formKey.currentState;

    if (formState == null) {
      return;
    }

    final value = formState.value();
    Navigator.of(context).pop(value);
  }
}
