part of 'mad_navigation_service_impl.dart';

extension on MadNavigationState {
  MadNavigationState _pushToRootStack(AnyNavRoute page, {MadNavigationState? initialState}) {
    final MadNavigationState state = initialState ?? this;
    final RouteStack stack = state.rootStack.copy()..add(page);

    return state.copyWith(rootStack: stack);
  }

  MadNavigationState _replaceInRootStack({
    required AnyNavRoute oldPage,
    required AnyNavRoute newPage,
  }) {
    final RouteStack rootStack = this.rootStack.copy();
    final int index = rootStack.indexWhere(NavRoute.isRoutePredicate(oldPage));

    assert(index >= 0, 'This Navigator does not contain the specified oldRoute in root.');

    return copyWith(
      rootStack: rootStack.replace(oldItem: rootStack.elementAt(index), newItem: newPage),
    );
  }

  MadNavigationState _pop({Object? lastResult, MadNavigationState? initialState}) {
    final MadNavigationState state = initialState ?? this;

    if (state.rootStack.length < 2) return state;

    if (pageUnknownOpen) {
      return state.copyWith(pageUnknownOpen: false);
    }

    final RouteStack rootStack = state.rootStack.copy();

    return state.copyWith(
      rootStack: rootStack..remove(rootStack.last..complete(lastResult)),
      lastResult: lastResult.nullable(),
    );
  }

  MadNavigationState _popAndPushRootStack(AnyNavRoute page, {Object? lastResult}) {
    final MadNavigationState stateAfterPop = _pop(lastResult: lastResult);
    final MadNavigationState stateAfterPush = _pushToRootStack(page, initialState: stateAfterPop);

    return stateAfterPush.copyWith(lastResult: lastResult.nullable());
  }

  MadNavigationState _popUntil(NavRoutePredicate predicate) {
    MadNavigationState state = this;

    if (state.rootStack.length < 2) return state;

    RouteStack stack = state.rootStack;

    AnyNavRoute? candidate = stack.lastOrNull;
    while (candidate != null) {
      if (predicate(candidate)) return state;

      state = _pop(initialState: state);

      if (state.rootStack.length < 2) return state;

      stack = state.rootStack;
      candidate = stack.lastOrNull;
    }

    return state;
  }

  MadNavigationState _pushAndRemoveUntilForRootStack(AnyNavRoute page, NavRoutePredicate predicate) {
    final MadNavigationState stateAfterPopUntil = _popUntil(predicate);

    return _pushToRootStack(page, initialState: stateAfterPopUntil);
  }
}

extension _SetExt<T> on Set<T> {
  Set<T> copy() => <T>{...this};

  int indexWhere(bool Function(T) test, [int start = 0]) {
    for (int i = start; i < length; i++) {
      if (test(elementAt(i))) return i;
    }

    return -1;
  }

  Set<T> replace({required T oldItem, required T newItem}) {
    return <T>{
      for (final T item in this) item == oldItem ? newItem : item,
    };
  }
}
