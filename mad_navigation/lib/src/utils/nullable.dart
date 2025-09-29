import 'package:mad_navigation/src/src.dart';

/// A wrapper class that makes any value nullable and equatable.
///
/// This is useful for handling nullable values in a type-safe way and
/// providing proper equality comparison.
class Nullable<T> extends Equatable with Stringify {
  /// Creates a new [Nullable] instance with the provided [value].
  const Nullable(this.value);

  /// The wrapped nullable value.
  final T value;

  @override
  List<Object?> get props => <Object?>[value];

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{
        'value': value,
      };
}

/// Extension that adds nullable conversion capabilities to all objects.
extension NullableContext on Object? {
  /// Converts a nullable object to a [Nullable] wrapper.
  ///
  /// This allows for type-safe handling of potentially null values.
  Nullable<T> nullable<T>() => Nullable<T>(this as T);
}
