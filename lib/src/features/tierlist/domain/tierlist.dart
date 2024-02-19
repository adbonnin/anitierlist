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
}
