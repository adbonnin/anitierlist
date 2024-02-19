import 'package:anitierlist/src/features/anilist/application/anilist_service.dart';
import 'package:anitierlist/src/features/anilist/data/browse_characters.graphql.dart';
import 'package:anitierlist/src/features/anime/presentation/tierlist/anime_tierlist_card.dart';
import 'package:anitierlist/src/widgets/sized_paged_grid_view.dart';
import 'package:anitierlist/styles.dart';
import 'package:collection/collection.dart';
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
  final void Function(Query$BrowseCharacters$Page$characters character) onCharacterTap;

  @override
  ConsumerState<CharacterAddGridView> createState() => _CharacterSearchGridViewState();
}

class _CharacterSearchGridViewState extends ConsumerState<CharacterAddGridView> {
  late final PagingController<int, Query$BrowseCharacters$Page$characters> _pagingController;

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
      itemWidth: AnimeTierListCard.width,
      itemHeight: AnimeTierListCard.height,
      mainAxisSpacing: Insets.p6,
      crossAxisSpacing: Insets.p6,
      pagingController: _pagingController,
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    final service = ref.read(anilistServiceProvider);
    final pagingState = _pagingController.value;

    if (pageKey != pagingState.nextPageKey) {
      return;
    }

    try {
      final result = await service.browseCharacters(
        search: widget.search,
        page: pageKey,
        perPage: 12,
      );

      if (!identical(pagingState, _pagingController.value)) {
        return;
      }

      final page = result.parsedData?.Page;
      final characters = (page?.characters ?? []).whereNotNull().toList();
      final hasNextPage = (page?.pageInfo?.hasNextPage ?? false) && characters.isNotEmpty;

      if (hasNextPage) {
        _pagingController.appendPage(characters, pageKey + 1);
      } //
      else {
        _pagingController.appendLastPage(characters);
      }
    } //
    catch (error) {
      _pagingController.error = error;
    }
  }

  Widget _buildItem(BuildContext context, Query$BrowseCharacters$Page$characters item, int index) {
    return AnimeTierListCard(
      title: item.name?.userPreferred ?? '',
      cover: item.image?.medium,
      onTap: () => widget.onCharacterTap(item),
    );
  }
}
