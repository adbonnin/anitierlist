import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/l10n/app_localization_extension.dart';
import 'package:anitierlist/src/utils/image_extensions.dart';
import 'package:anitierlist/src/utils/iterable_extensions.dart';
import 'package:anitierlist/src/utils/number.dart';
import 'package:anitierlist/src/utils/string_extension.dart';
import 'package:anitierlist/src/widgets/screenshot.dart';
import 'package:archive/archive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tierlist_service.g.dart';

@Riverpod(keepAlive: true)
TierListService tierListService(TierListServiceRef ref) {
  return TierListService.fromFirestore(FirebaseFirestore.instance);
}

class TierListService {
  const TierListService(this.firestore, this.tierListCollection);

  final FirebaseFirestore firestore;
  final TierListCollectionReference tierListCollection;

  factory TierListService.fromFirestore(FirebaseFirestore firestore) {
    final tierListCollection = TierListCollectionReference(firestore);
    return TierListService(firestore, tierListCollection);
  }

  Stream<List<TierList>> tierLists() {
    final snapshot = tierListCollection.snapshots();
    return snapshot.map((event) => event.snapshot.docs.map((e) => e.data()).toList());
  }

  Stream<List<TierListItem>> tierListItems(String tierListId) {
    final tierListDoc = tierListCollection.doc(tierListId).reference;

    final snapshot = TierListItemCollectionReference(tierListDoc).whereValue().snapshots();
    return snapshot.map((event) => event.snapshot.docs.map((e) => e.data()).toList());
  }

  Future<void> addItem(String tierListId, TierListItem item) {
    final tierListDoc = tierListCollection.doc(tierListId).reference;

    return TierListItemCollectionReference(tierListDoc).doc(item.id).set(item);
  }

  Future<void> addAllItems(String tierListId, Iterable<TierListItem> items) {
    final tierListDoc = tierListCollection.doc(tierListId).reference;
    final tierListItemCollection = TierListItemCollectionReference(tierListDoc);

    final batch = firestore.batch();

    for (final item in items) {
      batch.set(tierListItemCollection.doc(item.id).reference, item);
    }

    return batch.commit();
  }

  Future<void> removeItem(String tierListId, String itemId) {
    final tierListDoc = tierListCollection.doc(tierListId).reference;

    return TierListItemCollectionReference(tierListDoc).doc(itemId).delete();
  }

  static Iterable<String> notifyTierListItem(
    AppLocalizations loc,
    AsyncValue<Iterable<TierListItem>>? previous,
    AsyncValue<Iterable<TierListItem>> next,
  ) {
    final previousItems = previous?.valueOrNull;
    final nextItems = next.valueOrNull;

    if (previousItems == null || nextItems == null) {
      return [];
    }

    final messages = <String>[];
    final previousItemsById = previousItems.map((e) => (e.id, e)).toMap();

    for (final nextItem in nextItems) {
      final previousItem = previousItemsById.remove(nextItem.id);

      if (previousItem == null) {
        messages.add(loc.tierListItemAdded(nextItem));
      }
    }

    for (final previousItem in previousItemsById.values) {
      messages.add(loc.tierListItemRemoved(previousItem));
    }

    return messages;
  }

  static Future<Uint8List> buildZip(
    Map<String, List<(TierListItem, ScreenshotController)>> tierListScreenshotsByFormat, [
    String Function(String group)? toGroupLabel,
  ]) async {
    final archive = Archive();

    final total = tierListScreenshotsByFormat.values.map((list) => list.length).sum;
    var offset = 1;

    for (final etr in tierListScreenshotsByFormat.entries) {
      final group = etr.key;
      final imageControllers = etr.value.map((e) => e.$2).toList();

      final groupLabel = (toGroupLabel == null ? group : toGroupLabel(group)) //
          .removeSpecialCharacters()
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
      final nameItems = [index];

      if (groupText.isNotEmpty) {
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
