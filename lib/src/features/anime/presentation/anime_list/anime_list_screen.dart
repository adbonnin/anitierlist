import 'dart:math';

import 'package:anitierlist/src/features/anime/presentation/anime_edit/anime_edit_dialog.dart';
import 'package:anitierlist/src/features/tierlist/application/tierlist_providers.dart';
import 'package:anitierlist/src/features/tierlist/application/tierlist_service.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_group/tierlist_group_list.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_group/tierlist_group_title.dart';
import 'package:anitierlist/src/l10n/app_localization_extension.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/utils/anime.dart';
import 'package:anitierlist/src/utils/file.dart';
import 'package:anitierlist/src/utils/season.dart';
import 'package:anitierlist/src/widgets/async_value_widget.dart';
import 'package:anitierlist/src/widgets/info_label.dart';
import 'package:anitierlist/styles.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimeListScreen extends ConsumerStatefulWidget {
  const AnimeListScreen({super.key});

  @override
  ConsumerState<AnimeListScreen> createState() => _AnimeTierListScreenState();
}

class _AnimeTierListScreenState extends ConsumerState<AnimeListScreen> {
  final _groupListKey = GlobalKey<TierListGroupListState>();

  var _year = DateTime.now().year;
  var _season = DateTime.now().season;

  var _preferencesById = <String, TierListItem>{};
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    const firstYear = 1939;
    final lastYear = DateTime.now().year + 1;
    final years = List.generate(max(0, lastYear - firstYear), (index) => lastYear - index);

    final asyncAnime = ref.watch(browseTierListAnimeSeasonProvider(_year, _season));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: InfoLabel(
                labelText: context.loc.anime_tierlist_year,
                child: DropdownButtonFormField(
                  value: _year,
                  items: years //
                      .map(_buildYear)
                      .toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _onYearChanged,
                ),
              ),
            ),
            Gaps.p8,
            Expanded(
              child: InfoLabel(
                labelText: context.loc.anime_tierlist_season,
                child: DropdownButtonFormField(
                  value: _season,
                  items: Season.values //
                      .sorted(animeSeasonComparator)
                      .map(_buildSeason)
                      .toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _onSeasonChanged,
                ),
              ),
            ),
          ],
        ),
        Gaps.p8,
        Expanded(
          child: AsyncValueWidget(
            asyncAnime,
            data: (anime) => TierListGroupList(
              key: _groupListKey,
              items: anime.map(_applyPreference),
              onItemTap: _onAnimeTap,
              isLoading: _loading,
              groupTitleBuilder: _buildGroupTitle,
              onExportPressed: _onExportPressed,
              onSharePressed: _onSharePressed,
            ),
          ),
        ),
      ],
    );
  }

  void _onYearChanged(int? value) {
    if (value != null) {
      setState(() {
        _year = value;
      });
    }
  }

  void _onSeasonChanged(Season? value) {
    if (value != null) {
      setState(() {
        _season = value;
      });
    }
  }

  DropdownMenuItem<int> _buildYear(int year) {
    return DropdownMenuItem<int>(
      value: year,
      child: Text('$year'),
    );
  }

  DropdownMenuItem<Season> _buildSeason(Season season) {
    return DropdownMenuItem<Season>(
      value: season,
      child: Text(context.loc.season(season)),
    );
  }

  Widget _buildGroupTitle(BuildContext context, String group) {
    return TierListGroupTitle(
      titleText: context.loc.animeGroup(group),
    );
  }

  Future<void> _onAnimeTap(TierListItem anime) async {
    final updatedPreference = await showAnimeEditDialog(
      context: context,
      anime: anime,
    );

    if (updatedPreference == null) {
      return;
    }

    final updatedPreferencesById = {
      ..._preferencesById,
      anime.id: updatedPreference,
    };

    setState(() {
      _preferencesById = updatedPreferencesById;
    });
  }

  TierListItem _applyPreference(TierListItem anime) {
    return _preferencesById[anime.id] ?? anime;
  }

  Future<void> _onExportPressed() async {
    final tierListScreenshotsByFormat = _groupListKey.currentState?.buildTierListScreenshotsByFormat() ?? {};

    final seasonLabel = context.loc.season(_season);
    final name = context.loc.anime_tierlist_exportName(_year, seasonLabel);

    setState(() {
      _loading = true;
    });

    try {
      final bytes = await TierListService.buildZip(tierListScreenshotsByFormat, context.loc.animeGroup);
      await saveZipFile(name, bytes);
    } //
    finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _onSharePressed() async {
    final tierListScreenshotsByFormat = _groupListKey.currentState?.buildTierListScreenshotsByFormat() ?? {};
    final name = context.loc.characters_title;

    setState(() {
      _loading = true;
    });

    try {
      final bytes = await TierListService.buildZip(tierListScreenshotsByFormat);
      await shareZipFile(name, bytes);
    } //
    finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
