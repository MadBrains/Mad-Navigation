part of 'mad_navigation_service_impl.dart';

mixin _NavigatorBlocMixin on BasicBloc<MadNavigationEvent, MadNavigationState>
    implements MadNavigationService {
  @override
  Stream<MadNavigationState> get stateStream => stream;

  @override
  Future<T?> pushToRoot<T>(NavRoute<T> route) {
    add(NavigationPushRootRouteEvent(route));

    return route.popped;
  }

  @override
  void refresh() {
    add(const NavigationRefreshEvent());
  }

  @override
  void replaceInRoot<T>({
    required NavRoute<T> oldRoute,
    required NavRoute<T> newRoute,
  }) {
    if (oldRoute == newRoute) return;

    add(
      NavigationReplaceRootRouteEvent(oldRoute: oldRoute, newRoute: newRoute),
    );
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
  Future<T?> popAndPushToRoot<T>(NavRoute<T> route, {Object? result}) {
    add(NavigationPopAndPushRootRouteEvent(route, result: result));

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
  void resetRootStack(RouteStack stack) {
    add(NavigationResetRootStackEvent(stack));
  }
}
