import 'dart:io';
import 'dart:math';

import 'package:anitierlist/src/features/anime/application/anime_service.dart';
import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/anime/domain/anime_preference.dart';
import 'package:anitierlist/src/features/anime/presentation/tierlist/anime_tierlist_group_list.dart';
import 'package:anitierlist/src/features/anime/presentation/tierlist_edit/anime_tierlist_edit_dialog.dart';
import 'package:anitierlist/src/l10n/app_localization_extension.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/utils/anime.dart';
import 'package:anitierlist/src/utils/image_extensions.dart';
import 'package:anitierlist/src/utils/number.dart';
import 'package:anitierlist/src/utils/season.dart';
import 'package:anitierlist/src/utils/string_extension.dart';
import 'package:anitierlist/src/widgets/async_value_widget.dart';
import 'package:anitierlist/src/widgets/info_label.dart';
import 'package:anitierlist/src/widgets/loading_icon.dart';
import 'package:anitierlist/src/widgets/screenshot.dart';
import 'package:anitierlist/styles.dart';
import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimeTierListScreen extends ConsumerStatefulWidget {
  const AnimeTierListScreen({super.key});

  @override
  ConsumerState<AnimeTierListScreen> createState() => _AnimeTierListScreenState();
}

class _AnimeTierListScreenState extends ConsumerState<AnimeTierListScreen> {
  final _groupListKey = GlobalKey<AnimeTierListGroupListState>();

  var _exportingThumbnails = false;

  var _year = DateTime.now().year;
  var _season = DateTime.now().season;

  var _preferencesById = <int, AnimePreference>{};

  @override
  Widget build(BuildContext context) {
    const firstYear = 1939;
    final lastYear = DateTime.now().year + 1;
    final years = List<int>.generate(max(0, lastYear - firstYear), (index) => lastYear - index);

    final asyncAnime = ref.watch(browseAnimeProvider(_year, _season));
    final cannotExportThumbnails = !asyncAnime.hasValue || asyncAnime.isLoading || _exportingThumbnails;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Insets.p16),
        child: Column(
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
            Gaps.p12,
            Expanded(
              child: AsyncValueWidget(
                asyncAnime,
                data: (anime) => Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: AnimeTierListGroupList(
                          key: _groupListKey,
                          anime: anime.map(_applyPreference).toList(),
                          onAnimeTap: _onAnimeTap,
                        ),
                      ),
                    ),
                    Gaps.p12,
                    Row(
                      children: [
                        FilledButton.icon(
                          onPressed: cannotExportThumbnails ? null : _exportThumbnails,
                          icon: LoadingIcon(Icons.collections, loading: _exportingThumbnails),
                          label: Text(_exportingThumbnails //
                              ? context.loc.anime_tierlist_exportingThumbnails
                              : context.loc.anime_tierlist_exportThumbnails),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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

  Future<void> _onAnimeTap(Anime anime) async {
    final updatedPreference = await showAnimeTierListEditDialog(
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

  Future<void> _exportThumbnails() async {
    setState(() {
      _exportingThumbnails = true;
    });

    try {
      final seasonLabel = context.loc.season(_season);

      final name = 'TierList $_year $seasonLabel';
      final bytes = await _buildZip();
      const ext = '.zip';
      const mimeType = MimeType.zip;

      if (bytes.isEmpty) {
        return;
      } //
      else if (kIsWeb) {
        await FileSaver.instance.saveFile(
          name: name,
          bytes: bytes,
          ext: ext,
          mimeType: mimeType,
        );
      } //
      else {
        final filePath = await FileSaver.instance.saveAs(
          name: name,
          bytes: bytes,
          ext: ext,
          mimeType: mimeType,
        );

        if (filePath != null) {
          await File(filePath).writeAsBytes(bytes);
        }
      }
    } //
    finally {
      setState(() {
        _exportingThumbnails = false;
      });
    }
  }

  Future<Uint8List> _buildZip() async {
    final archive = Archive();
    final loc = context.loc;

    final animeByFormat = _groupListKey.currentState?.buildAnimeScreenshotsByFormat() ?? {};
    final total = animeByFormat.values.map((list) => list.length).sum;

    var offset = 1;

    for (final etr in animeByFormat.entries) {
      final format = etr.key;
      final imageControllers = etr.value.map((e) => e.$2).toList();

      final groupText = loc //
          .animeFormat(format)
          .removeSpecialCharacters()
          .removeMultipleSpace();

      await _addCapturesToArchive(archive, total, offset, groupText, imageControllers);
      offset += imageControllers.length;
    }

    if (archive.isEmpty) {
      return Uint8List(0);
    }

    final outputStream = OutputStream(byteOrder: LITTLE_ENDIAN);
    final encoder = ZipEncoder();

    final bytes = encoder.encode(archive, output: outputStream)!;
    return Uint8List.fromList(bytes);
  }

  Future<void> _addCapturesToArchive(
    Archive archive,
    int total,
    int offset,
    String groupText,
    List<ScreenshotController> screenshotControllers,
  ) async {
    if (screenshotControllers.isEmpty) {
      return;
    }

    final numberFormat = Numbers.numberFormatFromDigits(screenshotControllers.length);

    for (var i = 0; i < screenshotControllers.length; i++) {
      final imageController = screenshotControllers[i];
      final image = await imageController.capture();

      if (image == null) {
        continue;
      }

      final index = numberFormat.format(offset + i);
      final imageBytes = await image.toByteArray();

      final file = ArchiveFile(
        '$index $groupText.png',
        await imageBytes.lengthInBytes,
        imageBytes,
      );

      archive.addFile(file);
    }
  }
}
