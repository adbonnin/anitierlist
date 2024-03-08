import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';

class AnimePreference {
  const AnimePreference({
    required this.customTitle,
    required this.userSelectedTitle,
  });

  final String customTitle;
  final TierListTitle userSelectedTitle;
}
