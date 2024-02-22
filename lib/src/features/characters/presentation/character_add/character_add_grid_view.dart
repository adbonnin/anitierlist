import 'package:anitierlist/src/features/characters/application/character_service.dart';
import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_list/tierlist_card.dart';
import 'package:anitierlist/src/widgets/sized_paged_grid_view.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CharacterAddGridView extends ConsumerStatefulWidget {
  const CharacterAddGridView({
    super.key,
    required this.search,
    this.characters = const {},
    required this.onCharacterTap,
  });

  final String search;
  final Set<Character> characters;
  final void Function(Character character) onCharacterTap;

  @override
  ConsumerState<CharacterAddGridView> createState() => _CharacterSearchGridViewState();
}

class _CharacterSearchGridViewState extends ConsumerState<CharacterAddGridView> {
  late final PagingController<int, Character> _pagingController;
  late Set<int> _characterIds;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController(firstPageKey: 1);
    _pagingController.addPageRequestListener(_fetchPage);
    _characterIds = widget.characters.map((c) => c.id).toSet();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CharacterAddGridView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.search != widget.search) {
      _pagingController.refresh();
    }

    if (oldWidget.characters != widget.characters) {
      _characterIds = widget.characters.map((c) => c.id).toSet();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ScrollShadow(
        child: SizedPagedGridView(
          itemBuilder: _buildItem,
          itemWidth: TierListCard.width,
          itemHeight: TierListCard.height,
          mainAxisSpacing: Insets.p6,
          crossAxisSpacing: Insets.p6,
          pagingController: _pagingController,
        ),
      ),
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    final service = ref.read(characterServiceProvider);
    final pagingState = _pagingController.value;
    final search = widget.search;

    if (pageKey != pagingState.nextPageKey) {
      return;
    }

    try {
      final result = await service.browseCharacters(search, pageKey);

      if (!identical(pagingState, _pagingController.value)) {
        return;
      }

      if (result.hasNextPage) {
        _pagingController.appendPage(result.value, pageKey + 1);
      } //
      else {
        _pagingController.appendLastPage(result.value);
      }
    } //
    catch (error) {
      _pagingController.error = error;
    }
  }

  Widget _buildItem(BuildContext context, Character item, int index) {
    final exists = _characterIds.contains(item.id);

    final tierList = TierList(
      id: item.id,
      title: item.name,
      cover: item.image,
    );

    return InkWell(
      onTap: () => widget.onCharacterTap(item),
      child: Stack(
        children: [
          TierListCard(
            tierList: tierList,
          ),
          if (exists)
            Container(
              color: Colors.black54,
            ),
        ],
      ),
    );
  }
}
