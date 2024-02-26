import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';

class CharacterSearchAnimeListTile extends StatelessWidget {
  const CharacterSearchAnimeListTile({
    super.key,
    required this.title,
    this.onTap,
  });

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title:  Text(
        title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
