part of 'mad_tab_navigation_service_impl.dart';

extension on MadTabNavigationState {
  MadTabNavigationState _changeTab(MadTabType tab) => copyWith(
        activeTab: tab,
        activeTabs: activeTabs.copy()..add(tab),
      );

  MadTabNavigationState _pushToTabStack(AnyNavRoute page, {MadTabNavigationState? initialState}) {
    final MadTabNavigationState state = initialState ?? this;
    final RouteStack tabStack = state.selectedStack.copy()..add(page);

    return _saveTabStack(
      activeTab,
      tabStack,
      initialState: state,
    ).copyWith(isJumpToTopOnRootPage: false);
  }

  MadTabNavigationState _saveTabStack(MadTabType tab, RouteStack stack, {MadTabNavigationState? initialState}) {
    final MadTabNavigationState state = initialState ?? this;
    final List<RouteStack> tabStacks = state.tabStacks.copy();
    tabStacks[tabs.indexOf(tab)] = stack;

    return state.copyWith(tabStacks: tabStacks);
  }

  MadTabNavigationState _replaceInTabStack({
    required AnyNavRoute oldPage,
    required AnyNavRoute newPage,
  }) {
    final RouteStack tabStack = selectedStack.copy();
    final int index = tabStack.indexWhere(NavRoute.isRoutePredicate(oldPage));

    assert(index >= 0, 'This Navigator does not contain the specified oldRoute in selected tab.');

    return _saveTabStack(
      activeTab,
      tabStack.replace(oldItem: tabStack.elementAt(index), newItem: newPage),
    );
  }

  MadTabNavigationState _pop({Object? lastResult, MadTabNavigationState? initialState}) {
    MadTabNavigationState state = initialState ?? this;

    if (state.rootStack.length > 1) {
      state = _popRoot(lastResult, initialState: state);
    } else if (state.selectedStack.length > 1) {
      state = _popTabStack(lastResult, initialState: state);
    } else {
      return state;
    }

    return state.copyWith(lastResult: lastResult.nullable());
  }

  MadTabNavigationState _popRoot(Object? lastResult, {MadTabNavigationState? initialState}) {
    final MadTabNavigationState state = initialState ?? this;

    if (pageUnknownOpen) {
      return state.copyWith(pageUnknownOpen: false);
    }

    final RouteStack rootStack = state.rootStack.copy();

    return state.copyWith(
      rootStack: rootStack..remove(rootStack.last..complete(lastResult)),
    );
  }

  MadTabNavigationState _popTabStack(Object? lastResult, {MadTabNavigationState? initialState}) {
    final MadTabNavigationState state = initialState ?? this;
    final RouteStack tabStack = state.selectedStack.copy();

    return _saveTabStack(
      activeTab,
      tabStack..remove(tabStack.last..complete(lastResult)),
      initialState: state,
    );
  }

  MadTabNavigationState _popToRootPageInTab(
    MadTabType tab,
    AnyNavRoute rootPage,
  ) {
    if (activeRoute == rootPage) {
      return copyWith(isJumpToTopOnRootPage: true);
    }

    return _saveTabStack(tab, <AnyNavRoute>{rootPage});
  }

  MadTabNavigationState _popAndPushTabStack(AnyNavRoute page, {Object? lastResult}) {
    final MadTabNavigationState stateAfterPop = _popTabStack(lastResult);
    final MadTabNavigationState stateAfterPush = _pushToTabStack(page, initialState: stateAfterPop);

    return stateAfterPush.copyWith(lastResult: lastResult.nullable());
  }

  MadTabNavigationState _popUntil(NavRoutePredicate predicate) {
    MadTabNavigationState state = this;

    final RouteStack? initialStack = _getStack(initialState: state);
    if (initialStack == null) return state;

    RouteStack stack = initialStack;

    AnyNavRoute? candidate = stack.lastOrNull;
    while (candidate != null) {
      if (predicate(candidate)) return state;

      state = _pop(initialState: state);

      final RouteStack? tmpStack = _getStack(initialState: state);
      if (tmpStack == null) return state;

      stack = tmpStack;
      candidate = stack.lastOrNull;
    }

    return state;
  }

  RouteStack? _getStack({MadTabNavigationState? initialState}) {
    final MadTabNavigationState state = initialState ?? this;

    if (state.rootStack.length > 1) return state.rootStack;

    if (state.selectedStack.length > 1) return state.selectedStack;

    return null;
  }

  MadTabNavigationState _pushAndRemoveUntilForTabStack(AnyNavRoute page, NavRoutePredicate predicate) {
    final MadTabNavigationState stateAfterPopUntil = _popUntil(predicate);

    return _pushToTabStack(page, initialState: stateAfterPopUntil);
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

extension _ListExt<T> on List<T> {
  List<T> copy() => <T>[...this];
}
