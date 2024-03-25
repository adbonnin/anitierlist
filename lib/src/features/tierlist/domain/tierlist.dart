import 'package:anitierlist/src/features/tierlist/domain/tierlist_value.dart';
import 'package:anitierlist/src/utils/firestore.dart';
import 'package:anitierlist/src/utils/iterable_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';

part 'tierlist.g.dart';

@firestoreSerializable
class TierList {
  const TierList({
    this.id = '',
    this.name = '',
  });

  @Id()
  final String id;

  final String name;

  factory TierList.fromJson(Map<String, Object?> json) => //
      _$TierListFromJson(json);

  Map<String, Object?> toJson() => //
      _$TierListToJson(this);

  TierList copyWith({
    String? name,
  }) {
    return TierList(
      name: name ?? this.name,
    );
  }
}

@firestoreSerializable
class TierListItem {
  const TierListItem({
    required this.id,
    this.group = '',
    this.customTitle = '',
    this.selectedTitle = TierListTitle.undefined,
    required this.value,
  });

  @Id()
  final String id;
  final String group;
  final String customTitle;
  final String selectedTitle;

  @TierListValueConverter()
  final TierListValue value;

  String title() {
    final titles = value.titles;

    if (selectedTitle == TierListTitle.custom && customTitle.isNotEmpty) {
      return customTitle;
    }

    final selected = selectedTitle.isEmpty ? null : titles[selectedTitle];
    return selected ?? titles.values.firstOrNull ?? '';
  }

  factory TierListItem.fromJson(Map<String, Object?> json) => //
      _$TierListItemFromJson(json);

  Map<String, Object?> toJson() => //
      _$TierListItemToJson(this);

  TierListItem copyWith({
    String? id,
    String? group,
    String? customTitle,
    String? selectedTitle,
    TierListValue? value,
  }) {
    return TierListItem(
      id: id ?? this.id,
      group: group ?? this.group,
      customTitle: customTitle ?? this.customTitle,
      selectedTitle: selectedTitle ?? this.selectedTitle,
      value: value ?? this.value,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! TierListItem) {
      return false;
    }

    return runtimeType == other.runtimeType && //
        id == other.id &&
        group == other.group &&
        selectedTitle == other.selectedTitle &&
        value == other.value;
  }

  @override
  int get hashCode {
    return id.hashCode ^ //
        group.hashCode ^
        selectedTitle.hashCode ^
        value.hashCode;
  }
}

extension CharacterIterableExtension on Iterable<TierListItem> {
  Map<String, TierListItem> toMapById() {
    return map((e) => (e.id, e)).toMap();
  }
}

@Collection<TierList>('tierlists')
@Collection<TierListItem>('tierlists/*/items')
final tierListsRef = TierListCollectionReference();
