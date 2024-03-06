import 'package:anitierlist/src/features/characters/domain/character.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tier_item_card.dart';
import 'package:anitierlist/src/utils/graphql.dart';
import 'package:anitierlist/src/widgets/sized_paged_grid_view.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

typedef CharacterWidgetBuilder = Widget Function(BuildContext context, Character character, int index);

class CharacterPagedGridView extends StatefulWidget {
  const CharacterPagedGridView({
    super.key,
    required this.itemFinder,
    required this.itemBuilder,
  });

  final PagedItemFinder<Character> itemFinder;
  final CharacterWidgetBuilder itemBuilder;

  @override
  State<CharacterPagedGridView> createState() => _CharacterPagedGridViewState();
}

class _CharacterPagedGridViewState extends State<CharacterPagedGridView> {
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
  void didUpdateWidget(CharacterPagedGridView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.itemFinder != widget.itemFinder) {
      _pagingController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedPagedGridView(
      itemBuilder: widget.itemBuilder,
      itemWidth: TierItemCard.width,
      itemHeight: TierItemCard.height,
      mainAxisSpacing: Insets.p6,
      crossAxisSpacing: Insets.p6,
      pagingController: _pagingController,
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    final pagingState = _pagingController.value;

    if (pageKey != pagingState.nextPageKey) {
      return;
    }

    try {
      final result = await widget.itemFinder(pageKey);

      if (!identical(pagingState, _pagingController.value)) {
        return;
      }

      if (mounted) {
        if (result.hasNextPage) {
          _pagingController.appendPage(result.value, pageKey + 1);
        } //
        else {
          _pagingController.appendLastPage(result.value);
        }
      }
    } //
    catch (error) {
      if (mounted) {
        _pagingController.error = error;
      }
    }
  }
}
