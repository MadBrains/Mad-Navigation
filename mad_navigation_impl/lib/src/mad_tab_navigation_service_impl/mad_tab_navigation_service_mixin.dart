part of 'mad_tab_navigation_service_impl.dart';

mixin _TabNavigatorBlocMixin
    on BasicBloc<MadNavigationEvent, MadNavigationState>
    implements MadTabNavigationService {
  @override
  Stream<MadTabNavigationState> get stateStream => stream.cast();

  @override
  void selectTabByUser(MadTabType tab) {
    add(NavigationSelectTabByUserEvent(tab));
  }

  @override
  void changeTab(MadTabType tab) {
    final int index = state.tabs.indexOf(tab);
    if (index > -1) {
      add(NavigationChangeTabEvent(tab));
    }
  }

  @override
  Future<T?> pushToCurrentTab<T>(NavRoute<T> route) {
    add(NavigationPushTabRouteEvent(route));

    return route.popped;
  }

  @override
  void replaceInTab<T>({
    required NavRoute<T> oldRoute,
    required NavRoute<T> newRoute,
  }) {
    if (oldRoute == newRoute) return;

    add(NavigationReplaceTabRouteEvent(oldRoute: oldRoute, newRoute: newRoute));
  }

  @override
  bool pop({Object? result}) {
    if (state.canPop) {
      add(NavigationPopEvent(result: result));

      return true;
    }

    return false;
  }

  @override
  Future<T?> popAndPushToCurrentTab<T>(NavRoute<T> route, {Object? result}) {
    add(NavigationPopAndPushTabRouteEvent(route, result: result));

    return route.popped;
  }

  @override
  void popUntil(NavRoutePredicate predicate) {
    add(NavigationPopUntilEvent(predicate));
  }

  @override
  Future<T?> pushAndRemoveUntilForRootStack<T>(
    NavRoute<T> route, {
    required NavRoutePredicate predicate,
  }) {
    add(
      NavigationPushAndRemoveUntilForRootStackEvent(
        route: route,
        predicate: predicate,
      ),
    );

    return route.popped;
  }

  @override
  Future<T?> pushAndRemoveUntilForTabStack<T>(
    NavRoute<T> route, {
    required NavRoutePredicate predicate,
  }) {
    add(
      NavigationPushAndRemoveUntilForTabStackEvent(
        route: route,
        predicate: predicate,
      ),
    );

    return route.popped;
  }

  @override
  void resetTabStack(RouteStack stack, {required MadTabType tab}) {
    add(NavigationResetTabStackEvent(tab: tab, stack: stack));
  }

  @override
  void resetJumpToTopOnRootPage() {
    add(const NavigationResetJumpToTopOnRootPageEvent());
  }
}
