import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValues {
  static AsyncValue<(A, B)> group2<A, B>(
    AsyncValue<A> asyncValue1,
    AsyncValue<B> asyncValue2,
  ) {
    return switch ((
      asyncValue1,
      asyncValue2,
    )) {
      (
        AsyncValue(value: final value1, hasValue: true),
        AsyncValue(value: final value2, hasValue: true),
      ) =>
        AsyncData((
          value1!,
          value2!,
        )),
      (AsyncError(:final error, :final stackTrace), _) ||
      (_, AsyncError(:final error, :final stackTrace)) =>
        AsyncError(error, stackTrace),
      _ => const AsyncLoading(),
    };
  }
}
