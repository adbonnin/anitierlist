import 'package:anitierlist/src/utils/graphql.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class GraphqlListView<T> extends StatefulWidget {
  const GraphqlListView({
    super.key,
    required this.itemFinder,
    required this.itemBuilder,
    required this.firstPageKey,
  });

  final PagedItemFinder<T> itemFinder;
  final ItemWidgetBuilder<T> itemBuilder;
  final int firstPageKey;

  @override
  State<GraphqlListView> createState() => _GraphqlListViewState();
}

class _GraphqlListViewState<T> extends State<GraphqlListView<T>> {
  late final PagingController<int, T> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController(firstPageKey: widget.firstPageKey);
    _pagingController.addPageRequestListener(_fetchPage);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GraphqlListView<T> oldWidget) {
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
