class PagedResult<T> {
  const PagedResult({
    required this.value,
    required this.hasNextPage,
  });

  final T value;
  final bool hasNextPage;
}
