/// A mixin that provides a custom string representation of an object.
mixin Stringify {
  /// A map of field names to their values for string representation.
  ///
  /// Override this getter to include the desired fields in the string output.
  Map<String, dynamic> get mappedFields => <String, dynamic>{};

  @override
  String toString() => '$runtimeType ${mappedFields.toString()}';
}
