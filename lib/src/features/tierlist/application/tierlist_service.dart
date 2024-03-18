import 'package:anitierlist/src/features/anime/application/anime_service.dart';
import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/utils/image_extensions.dart';
import 'package:anitierlist/src/utils/iterable_extensions.dart';
import 'package:anitierlist/src/utils/number.dart';
import 'package:anitierlist/src/utils/season.dart';
import 'package:anitierlist/src/utils/string_extension.dart';
import 'package:anitierlist/src/widgets/screenshot.dart';
import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tierlist_service.g.dart';

class TierListService {
  const TierListService();

  static Future<Uint8List> buildZip(
    Map<String?, List<(TierListItem, ScreenshotController)>> tierListScreenshotsByFormat, [
    String Function(String group)? toGroupLabel,
  ]) async {
    final archive = Archive();

    final total = tierListScreenshotsByFormat.values.map((list) => list.length).sum;
    var offset = 1;

    for (final etr in tierListScreenshotsByFormat.entries) {
      final group = etr.key;
      final imageControllers = etr.value.map((e) => e.$2).toList();

      final groupLabel = (toGroupLabel == null || group == null ? group : toGroupLabel.call(group)) //
          ?.removeSpecialCharacters()
          .removeMultipleSpace();

      await _addCapturesToArchive(archive, total, offset, groupLabel, imageControllers);
      offset += imageControllers.length;
    }

    if (archive.isEmpty) {
      return Uint8List(0);
    }

    final output = OutputStream(byteOrder: LITTLE_ENDIAN);
    final encoder = ZipEncoder();

    final bytes = encoder.encode(archive, output: output)!;
    return Uint8List.fromList(bytes);
  }

  static Future<void> _addCapturesToArchive(
    Archive archive,
    int total,
    int offset,
    String? groupText,
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
      final nameItems = [index];

      if (groupText != null && groupText.isNotEmpty) {
        nameItems.add(groupText);
      }

      final name = '${nameItems.join(' ')}.png';
      final imageBytes = await image.toByteArray();
      final imageBytesLength = await imageBytes.lengthInBytes;

      final file = ArchiveFile(name, imageBytesLength, imageBytes);
      archive.addFile(file);
    }
  }
}

@Riverpod()
AsyncValue<Iterable<TierListItem>> browseTierListAnimeSeason(
  BrowseTierListAnimeSeasonRef ref,
  int year,
  Season season,
) {
  final asyncBrowseAnimeSeason = ref.watch(browseAnimeSeasonProvider(year, season));

  TierListItem toItem(Anime anime) {
    return TierListItem(
      id: anime.itemId,
      group: anime.format.name,
      value: anime,
    );
  }

  return asyncBrowseAnimeSeason.whenData((anime) => anime //
      .stableSorted((a, b) => a.format.index - b.format.index)
      .map(toItem));
}
