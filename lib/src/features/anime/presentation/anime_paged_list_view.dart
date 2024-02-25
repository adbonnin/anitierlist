import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:anitierlist/src/utils/graphql.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

typedef AnimeWidgetBuilder = Widget Function(BuildContext context, Anime anime, int index);

class AnimePagedListView extends StatefulWidget {
  const AnimePagedListView({
    super.key,
    required this.itemFinder,
    required this.itemBuilder,
  });

  final PagedItemFinder<Anime> itemFinder;
  final AnimeWidgetBuilder itemBuilder;

  @override
  State<AnimePagedListView> createState() => _AnimePagedListViewState();
}

class _AnimePagedListViewState extends State<AnimePagedListView> {
  late final PagingController<int, Anime> _pagingController;

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
  void didUpdateWidget(AnimePagedListView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.itemFinder != widget.itemFinder) {
      _pagingController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: widget.itemBuilder,
      ),
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
}
