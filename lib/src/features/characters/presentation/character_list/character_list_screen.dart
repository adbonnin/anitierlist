import 'package:anitierlist/src/features/anilist/data/browse_characters.graphql.dart';
import 'package:anitierlist/src/features/characters/presentation/character_add/character_add_dialog.dart';
import 'package:flutter/material.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddCharacterPressed,
        child: const Icon(Icons.person_add),
      ),
      body: const Placeholder(),
    );
  }

  void _onAddCharacterPressed() {
    showCharacterAddDialog(
      context: context,
      onCharacterTap: _onAddCharacter,
    );
  }

  void _onAddCharacter(Query$BrowseCharacters$Page$characters character) {
    print('Add ${character.name?.userPreferred ?? ''}');
  }
}
