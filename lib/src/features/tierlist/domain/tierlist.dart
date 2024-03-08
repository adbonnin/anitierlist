import 'package:anitierlist/src/utils/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tierlist.g.dart';

@firestoreSerializable
class TierList {
  const TierList({
    required this.id,
    this.name = '',
  });

  @Id()
  final String id;

  final String name;

  factory TierList.fromJson(Map<String, Object?> json) => //
      _$TierListFromJson(json);

  Map<String, Object?> toJson() => //
      _$TierListToJson(this);
}

@firestoreSerializable
class TierListItem {
  const TierListItem({
    required this.id,
    this.type = TierListType.$unknown,
    this.group = '',
    this.titles = const {},
    this.customTitle = '',
    this.userSelectedTitle = TierListTitle.$unknown,
    this.cover,
  });

  @Id()
  final String id;

  @JsonKey(unknownEnumValue: TierListType.$unknown)
  final TierListType type;

  final String group;
  final Map<TierListTitle, String> titles;
  final String customTitle;

  @JsonKey(unknownEnumValue: TierListTitle.$unknown)
  final TierListTitle userSelectedTitle;

  final String? cover;

  String get title {
    return titles.values.firstOrNull ?? '';
  }

  factory TierListItem.fromJson(Map<String, Object?> json) => //
      _$TierListItemFromJson(json);

  Map<String, Object?> toJson() => //
      _$TierListItemToJson(this);

  TierListItem copyWith(
    String? id,
    TierListType? type,
    String? group,
    Map<TierListTitle, String>? titles,
    String? customTitle,
    TierListTitle? userSelectedTitle,
    String? cover,
  ) {
    return TierListItem(
      id: id ?? this.id,
      type: type ?? this.type,
      group: group ?? this.group,
      titles: titles ?? this.titles,
      customTitle: customTitle ?? this.customTitle,
      userSelectedTitle: userSelectedTitle ?? this.userSelectedTitle,
      cover: cover ?? this.cover,
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

    return runtimeType == other.runtimeType &&
        id == other.id &&
        group == other.group &&
        titles == other.titles &&
        customTitle == other.customTitle &&
        userSelectedTitle == other.userSelectedTitle &&
        cover == other.cover;
  }

  @override
  int get hashCode {
    return id.hashCode ^ //
        group.hashCode ^
        titles.hashCode ^
        customTitle.hashCode ^
        userSelectedTitle.hashCode ^
        cover.hashCode;
  }
}

enum TierListTitle {
  english,
  native,
  userPreferred,
  custom,
  $unknown,
}

enum TierListType {
  anime,
  character,
  $unknown,
}

@Collection<TierList>('tierlists')
@Collection<TierListItem>('tierlists/*/items')
final tierListsRef = TierListCollectionReference();
