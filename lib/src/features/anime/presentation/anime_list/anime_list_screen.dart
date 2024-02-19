import 'dart:math';

import 'package:anitierlist/src/features/anime/application/anime_service.dart';
import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/anime/domain/anime_preference.dart';
import 'package:anitierlist/src/features/anime/presentation/anime_edit/anime_edit_dialog.dart';
import 'package:anitierlist/src/features/tierlist/application/tierlist_service.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_list/tierlist_group_list.dart';
import 'package:anitierlist/src/l10n/app_localization_extension.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/utils/anime.dart';
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

  var _preferencesById = <int, AnimePreference>{};
  var _exporting = false;

  @override
  Widget build(BuildContext context) {
    const firstYear = 1939;
    final lastYear = DateTime.now().year + 1;
    final years = List<int>.generate(max(0, lastYear - firstYear), (index) => lastYear - index);

    final asyncAnime = ref.watch(browseAnimeProvider(_year, _season));

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
              tierLists: anime //
                  .map(_applyPreference)
                  .map(_toTierList)
                  .toList(),
              onTierListTap: (tl) => _onAnimeTap(anime.where((a) => a.id == tl.id).firstOrNull),
              exporting: _exporting,
              toGroupLabel: context.loc.animeGroup,
              onExportPressed: _onExportPressed,
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

  Future<void> _onAnimeTap(Anime? anime) async {
    if (anime == null) {
      return;
    }

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

  Anime _applyPreference(Anime anime) {
    final preference = _preferencesById[anime.id];

    if (preference != null) {
      anime = anime.copyWith(
        customTitle: preference.customTitle,
        userSelectedTitle: preference.userSelectedTitle,
      );
    }

    return anime;
  }

  TierList _toTierList(Anime anime) {
    return TierList(
      id: anime.id,
      title: anime.title,
      group: anime.format.name,
      cover: anime.coverImageMedium,
    );
  }

  Future<void> _onExportPressed() async {
    final tierListScreenshotsByFormat = _groupListKey.currentState?.buildTierListScreenshotsByFormat() ?? {};

    final seasonLabel = context.loc.season(_season);
    final name = 'TierList $_year $seasonLabel';

    setState(() {
      _exporting = true;
    });

    try {
      final bytes = await TierListService.buildZip(tierListScreenshotsByFormat, context.loc.animeGroup);
      await TierListService.saveZipFile(name, bytes);
    } //
    finally {
      setState(() {
        _exporting = false;
      });
    }
  }
}
