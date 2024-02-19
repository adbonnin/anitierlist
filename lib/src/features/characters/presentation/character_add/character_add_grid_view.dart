import 'package:anitierlist/src/features/characters/application/character_service.dart';
import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_list/tierlist_card.dart';
import 'package:anitierlist/src/widgets/sized_paged_grid_view.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CharacterAddGridView extends ConsumerStatefulWidget {
  const CharacterAddGridView({
    super.key,
    required this.search,
    required this.onCharacterTap,
  });

  final String search;
  final void Function(Character character) onCharacterTap;

  @override
  ConsumerState<CharacterAddGridView> createState() => _CharacterSearchGridViewState();
}

class _CharacterSearchGridViewState extends ConsumerState<CharacterAddGridView> {
  late final PagingController<int, Character> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController(firstPageKey: 1);
    _pagingController.addPageRequestListener(_fetchPage);
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
  }

  @override
  Widget build(BuildContext context) {
    return SizedPagedGridView(
      itemBuilder: _buildItem,
      itemWidth: TierListCard.width,
      itemHeight: TierListCard.height,
      mainAxisSpacing: Insets.p6,
      crossAxisSpacing: Insets.p6,
      pagingController: _pagingController,
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
    final tierList = TierList(
      id: item.id,
      title: item.name,
      cover: item.image,
    );

    return TierListCard(
      tierList: tierList,
      onTap: () => widget.onCharacterTap(item),
    );
  }
}
