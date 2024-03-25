import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_edit/tierlist_edit_form.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';

Future<TierList?> showTierListEditDialog({
  required BuildContext context,
  TierList? tierList,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  return showDialog<TierList>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return TierListEditDialog(
        initialTierList: tierList,
      );
    },
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}

class TierListEditDialog extends StatefulWidget {
  const TierListEditDialog({
    super.key,
    this.initialTierList,
  });

  final TierList? initialTierList;

  @override
  State<TierListEditDialog> createState() => _TierListEditDialogState();
}

class _TierListEditDialogState extends State<TierListEditDialog> {
  final _formKey = GlobalKey<TierListEditFormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(widget.initialTierList == null //
          ? context.loc.tierlist_edit_createTitle
          : context.loc.tierlist_edit_editTitle),
      content: SizedBox(
        width: 360,
        child: TierListEditForm(
          key: _formKey,
          initialTierList: widget.initialTierList,
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: _onCancelPressed,
          child: Text(context.loc.common_cancel),
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
    final state = _formKey.currentState;

    if (state == null || !state.validate()) {
      return;
    }

    final value = state.value();

    final tierList = TierList(
      name: value.name,
    );

    return Navigator.of(context).pop(tierList);
  }
}
