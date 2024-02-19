import 'dart:io';

import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/utils/image_extensions.dart';
import 'package:anitierlist/src/utils/number.dart';
import 'package:anitierlist/src/utils/string_extension.dart';
import 'package:anitierlist/src/widgets/screenshot.dart';
import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';

class TierListService {
  const TierListService();

  static Future<void> saveFile(String name, Uint8List bytes) async {
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
  }

  static Future<Uint8List> buildZip(
    Map<String?, List<(TierList, ScreenshotController)>> tierListScreenshotsByFormat,
    String Function(String group) toGroupLabel,
  ) async {
    final archive = Archive();

    final total = tierListScreenshotsByFormat.values.map((list) => list.length).sum;
    var offset = 1;

    for (final etr in tierListScreenshotsByFormat.entries) {
      final group = etr.key;
      final imageControllers = etr.value.map((e) => e.$2).toList();

      final groupText = toGroupLabel(group ?? '') //
          .removeSpecialCharacters()
          .removeMultipleSpace();

      await _addCapturesToArchive(archive, total, offset, groupText, imageControllers);
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
