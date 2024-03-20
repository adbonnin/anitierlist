import 'package:anitierlist/src/features/anime/presentation/anime_edit/anime_edit_dialog.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist_value.dart';
import 'package:anitierlist/src/l10n/app_localization_extension.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/widgets/expanded_radio_list_tile.dart';
import 'package:anitierlist/src/widgets/info_label.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';

class AnimeEditForm extends StatefulWidget {
  const AnimeEditForm({
    super.key,
    required this.anime,
  });

  final TierListItem anime;

  @override
  State<AnimeEditForm> createState() => AnimeEditFormState();
}

class AnimeEditFormState extends State<AnimeEditForm> {
  late final TextEditingController _customTitleController;
  final _customTitleFocusNode = FocusNode();

  late String _selectedTitle;

  @override
  void initState() {
    super.initState();

    _customTitleController = TextEditingController(text: widget.anime.customTitle);
    _customTitleFocusNode.addListener(_handleCustomTitleFocus);

    _selectedTitle = widget.anime.selectedTitle;
  }

  @override
  void dispose() {
    _customTitleFocusNode.dispose();
    _customTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: InfoLabel(
        labelText: context.loc.anime_tierlist_edit_titleLabel,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExpandedRadioListTile(
              value: TierListTitle.undefined,
              groupValue: _selectedTitle,
              onChanged: _onUserSelectedTitleChanged,
              title: Text(context.loc.tierlist_undefinedTitle),
            ),
            for (final etr in widget.anime.value.titles.entries)
              ExpandedRadioListTile(
                value: etr.key,
                groupValue: _selectedTitle,
                onChanged: _onUserSelectedTitleChanged,
                title: Text(context.loc.animeTitle(etr.key)),
                subtitle: Text(
                  etr.value,
                  maxLines: null,
                ),
                onCopyPressed: () => _onCopyPressed(etr.value),
              ),
            ExpandedRadioListTile(
              value: TierListTitle.custom,
              groupValue: _selectedTitle,
              onChanged: _onUserSelectedTitleChanged,
              title: Text(context.loc.tierlist_customTitle),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: Insets.p2),
                child: TextFormField(
                  focusNode: _customTitleFocusNode,
                  controller: _customTitleController,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCustomTitleFocus() {
    if (_customTitleFocusNode.hasFocus) {
      setState(() {
        _selectedTitle = TierListTitle.custom;
      });
    }
  }

  void _onCopyPressed(String? text) {
    if (text != null) {
      _customTitleController.text = text;

      setState(() {
        _selectedTitle = TierListTitle.custom;
      });
    }
  }

  void _onUserSelectedTitleChanged(String? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _selectedTitle = value;
    });
  }

  AnimeEditDialogData value() {
    return AnimeEditDialogData(
      selectedTitle: _selectedTitle,
      customTitle: _customTitleController.text,
    );
  }
}
