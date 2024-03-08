import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/widgets/expanded_radio_list_tile.dart';
import 'package:anitierlist/src/widgets/info_label.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';

class AnimeEditFormData {
  const AnimeEditFormData({
    required this.userSelectedTitle,
    required this.customTitle,
  });

  final TierListTitle userSelectedTitle;
  final String customTitle;
}

class AnimeEditForm extends StatefulWidget {
  const AnimeEditForm({
    super.key,
    required this.anime,
  });

  final Anime anime;

  @override
  State<AnimeEditForm> createState() => AnimeEditFormState();
}

class AnimeEditFormState extends State<AnimeEditForm> {
  final _customTitleController = TextEditingController();
  final _customTitleFocusNode = FocusNode();

  late TierListTitle _userSelectedTitle;

  @override
  void initState() {
    super.initState();
    _userSelectedTitle = widget.anime.selectedTitle;
    _customTitleFocusNode.addListener(_handleCustomTitleFocus);
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
            if (widget.anime.englishTitle.isNotEmpty)
              ExpandedRadioListTile(
                value: TierListTitle.english,
                groupValue: _userSelectedTitle,
                onChanged: _onUserSelectedTitleChanged,
                title: Text(context.loc.anime_title_english),
                subtitle: Text(
                  widget.anime.englishTitle,
                  maxLines: null,
                ),
                onCopyPressed: () => _onCopyPressed(widget.anime.englishTitle),
              ),
            if (widget.anime.nativeTitle.isNotEmpty)
              ExpandedRadioListTile(
                value: TierListTitle.native,
                groupValue: _userSelectedTitle,
                onChanged: _onUserSelectedTitleChanged,
                title: Text(context.loc.anime_title_native),
                subtitle: Text(
                  widget.anime.nativeTitle,
                  maxLines: null,
                ),
                onCopyPressed: () => _onCopyPressed(widget.anime.nativeTitle),
              ),
            if (widget.anime.userPreferredTitle.isNotEmpty)
              ExpandedRadioListTile(
                value: TierListTitle.userPreferred,
                groupValue: _userSelectedTitle,
                onChanged: _onUserSelectedTitleChanged,
                title: Text(context.loc.anime_title_userPreferred),
                subtitle: Text(
                  widget.anime.userPreferredTitle,
                  maxLines: null,
                ),
                onCopyPressed: () => _onCopyPressed(widget.anime.userPreferredTitle),
              ),
            ExpandedRadioListTile(
              value: TierListTitle.custom,
              groupValue: _userSelectedTitle,
              onChanged: _onUserSelectedTitleChanged,
              title: Text(context.loc.anime_title_custom),
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
        _userSelectedTitle = TierListTitle.custom;
      });
    }
  }

  void _onCopyPressed(String? text) {
    if (text != null) {
      _customTitleController.text = text;

      setState(() {
        _userSelectedTitle = TierListTitle.custom;
      });
    }
  }

  void _onUserSelectedTitleChanged(TierListTitle? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _userSelectedTitle = value;
    });
  }

  AnimeEditFormData value() {
    return AnimeEditFormData(
      userSelectedTitle: _userSelectedTitle,
      customTitle: _customTitleController.text,
    );
  }
}
