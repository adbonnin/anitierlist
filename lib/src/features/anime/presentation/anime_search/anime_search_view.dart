import 'package:anitierlist/src/features/anime/application/anime_service.dart';
import 'package:anitierlist/src/features/anime/domain/anime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

typedef AnimeWidgetBuilder = Widget Function(BuildContext context, Anime anime, int index);

class AnimeSearchView extends ConsumerStatefulWidget {
  const AnimeSearchView({
    super.key,
    required this.search,
    required this.itemBuilder,
  });

  final String search;
  final AnimeWidgetBuilder itemBuilder;

  @override
  ConsumerState<AnimeSearchView> createState() => _CharacterSearchGridViewState();
}

class _CharacterSearchGridViewState extends ConsumerState<AnimeSearchView> {
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
  void didUpdateWidget(AnimeSearchView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.search != widget.search) {
      _pagingController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ScrollShadow(
        child: PagedListView(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: widget.itemBuilder,
          ),
        ),
      ),
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    final service = ref.read(animeServiceProvider);
    final pagingState = _pagingController.value;
    final search = widget.search;

    if (pageKey != pagingState.nextPageKey) {
      return;
    }

    try {
      final result = await service.searchAnime(search, pageKey);

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
