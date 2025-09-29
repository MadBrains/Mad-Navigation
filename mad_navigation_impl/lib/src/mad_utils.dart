/// A type alias that defines a function type for extracting state properties to track changes.
///
/// This function takes a state of type [S] and returns a list of objects that represent
/// the state properties to be compared for changes.
typedef MadBlocUponCondition<S> = List<Object?> Function(S state);

/// A type alias that defines a function type for determining if a state change is significant.
///
/// This function takes the previous state and current state of type [S] and returns
/// `true` if the change is considered significant and should trigger a listener.
typedef MadBlocListenerCondition<S> = bool Function(S previous, S current);

/// Extension on [MadBlocUponCondition] that provides utility methods for working with
/// state change conditions.
extension MadBlocUponConditionExt<S> on MadBlocUponCondition<S> {
  /// Converts a [MadBlocUponCondition] to a [MadBlocListenerCondition].
  ///
  /// The resulting condition will return `true` if any of the values in the list
  /// returned by the [MadBlocUponCondition] have changed between states.
  ///
  /// Returns `null` if the resulting condition would never be `true`.
  MadBlocListenerCondition<S>? form() {
    return (S previous, S current) {
      final List<Object?> listPrev = this(previous);
      final List<Object?> listCurrent = this(current);

      // If the lists have different lengths, they are considered different
      if (listPrev.length != listCurrent.length) {
        return true;
      }

      // Check if any corresponding elements are different
      for (int i = 0; i < listPrev.length; i++) {
        if (listPrev[i] != listCurrent[i]) {
          return true;
        }
      }

      return false;
    };
  }
}
