import 'package:anitierlist/src/utils/iterable_extensions.dart';

typedef PagedItemFinder<T> = Future<PagedResult<List<T>>> Function(int page);

class PagedResult<T> {
  const PagedResult({
    required this.value,
    required this.hasNextPage,
  });

  final T value;
  final bool hasNextPage;

  static Future<Iterable<T>> queryIterables<T>(PagedItemFinder<T> query) async {
    final pages = <Iterable<T>>[];
    bool hasNextPage = true;

    while (hasNextPage) {
      final result = await query(pages.length + 1);

      pages.add(result.value);
      hasNextPage = result.hasNextPage;
    }

    return pages.flatten();
  }
}
