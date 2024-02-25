typedef PagedItemFinder<T> = Future<PagedResult<List<T>>> Function(int page);

class PagedResult<T> {
  const PagedResult({
    required this.value,
    required this.hasNextPage,
  });

  final T value;
  final bool hasNextPage;
}
