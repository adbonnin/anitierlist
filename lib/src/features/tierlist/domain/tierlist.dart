class TierList {
  const TierList({
    required this.id,
    required this.title,
    this.group,
    this.cover,
  });

  final int id;
  final String title;
  final String? group;
  final String? cover;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! TierList) {
      return false;
    }

    return runtimeType == other.runtimeType &&
        id == other.id &&
        title == other.title &&
        group == other.group &&
        cover == other.cover;
  }

  @override
  int get hashCode {
    return id.hashCode ^ //
        title.hashCode ^
        group.hashCode ^
        cover.hashCode;
  }
}
