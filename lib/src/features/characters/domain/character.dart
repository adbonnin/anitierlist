import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';

class Character {
  const Character({
    required this.id,
    required this.name,
    required this.image,
  });

  final int id;
  final String name;
  final String? image;

  TierList toTierList() {
    return TierList(
      id: id,
      title: name,
      cover: image,
    );
  }
}
