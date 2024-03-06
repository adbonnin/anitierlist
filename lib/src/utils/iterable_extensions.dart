import 'package:collection/collection.dart';

extension IterableExtensions<E> on Iterable<E> {
  Iterable<E> intersperse(E Function(E previous, E next) generator) sync* {
    final iterator = this.iterator;
    late E previous;

    if (iterator.moveNext()) {
      previous = iterator.current;
      yield previous;
    }

    while (iterator.moveNext()) {
      final current = iterator.current;

      yield generator(previous, current);

      yield current;
      previous = current;
    }
  }

  Iterable<E> stableSorted(Comparator<E> compare) {
    int compareWithIndex((int, E) a, (int, E) b) {
      final c = compare(a.$2, b.$2);
      return c != 0 ? c : a.$1 - b.$1;
    }

    return mapIndexed((index, element) => (index, element)) //
        .sorted(compareWithIndex)
        .map((e) => e.$2);
  }
}

extension MapEntryIterableExtension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() {
    return Map.fromEntries(this);
  }
}

extension TupleIterableExtension<K, V> on Iterable<(K, V)> {
  Map<K, V> toMap() {
    return {
      for (var element in this) //
        element.$1: element.$2
    };
  }
}

extension IterableIterableExtension<E> on Iterable<Iterable<E>> {
  Iterable<E> flatten() {
    return expand((element) => element);
  }
}

extension ListExtension<E> on Iterable<E> {
  List<E> setLength(int newLength, E Function(int index) generator) {
    return [
      ...take(newLength),
      for (var i = length; i < newLength; i++) //
        generator(i),
    ];
  }
}
