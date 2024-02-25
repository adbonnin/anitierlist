import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';

class CharacterSearchAnimeCard extends StatelessWidget {
  const CharacterSearchAnimeCard({
    super.key,
    required this.title,
    this.onTap,
  });

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Insets.p6, horizontal: Insets.p12),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
