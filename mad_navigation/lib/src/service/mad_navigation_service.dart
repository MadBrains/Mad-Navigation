import 'package:mad_navigation/src/src.dart';

/// A predicate function type for route matching in navigation operations.
///
/// Used to determine if a given route matches certain conditions during navigation.
typedef NavRoutePredicate = bool Function(AnyNavRoute route);

/// A service interface for handling application navigation.
///
/// This service provides methods for managing the navigation stack and state
/// of the application.
abstract interface class MadNavigationService {
  /// A stream of navigation state changes.
  Stream<MadNavigationState> get stateStream;

  /// The current navigation state.
  MadNavigationState get state;

  /// Pushes a new route to the root navigation stack.
  ///
  /// The [route] specifies the route to push, where `T` is the type of result returned
  /// when the route is popped.
  ///
  /// Returns a [Future] that completes with the result of type `T` or `null`
  /// when the pushed route is removed from the stack.
  Future<T?> pushToRoot<T>(NavRoute<T> route);

  /// Refreshes the current navigation state.
  ///
  /// This can be used to force a rebuild of the navigation stack.
  void refresh();

  /// Replaces an existing [oldRoute] in the root stack with a [newRoute].
  void replaceInRoot<T>({
    required NavRoute<T> oldRoute,
    required NavRoute<T> newRoute,
  });

  /// Removes the current route from the navigation stack.
  ///
  /// If [result] is provided, it will be the return value of the
  /// [Future] that was returned when the route was pushed.
  ///
  /// Returns `true` if the pop was successful, `false` otherwise.
  bool pop({Object? result});

  /// Removes the current route and pushes a new route to the root stack.
  ///
  /// The [route] specifies the route to push, where `T` is the type of result returned
  /// when the route is popped.
  ///
  /// Returns a [Future] that completes with the result of type `T` or `null`
  /// when the pushed route is removed from the stack.
  Future<T?> popAndPushToRoot<T>(NavRoute<T> route);

  /// Removes routes until the given [predicate] is met.
  ///
  /// The [predicate] is called with each route in the stack until it returns true.
  void popUntil(NavRoutePredicate predicate);

  /// Pushes a route and removes all previous routes until the [predicate] is met.
  ///
  /// The [route] specifies the route to push, where `T` is the type of result returned
  /// when the route is popped. The [predicate] determines which routes to remove.
  ///
  /// Returns a [Future] that completes with the result of type `T` or `null`
  /// when the pushed route is removed from the stack.
  Future<T?> pushAndRemoveUntilForRootStack<T>(
    NavRoute<T> route, {
    required NavRoutePredicate predicate,
  });

  /// Resets the root navigation stack to the given [stack].
  ///
  /// This will replace the entire navigation stack.
  void resetRootStack(RouteStack stack);
}

/// A service interface for handling tab-based navigation.
///
/// Extends [MadNavigationService] with tab-specific navigation methods.
abstract interface class MadTabNavigationService extends MadNavigationService {
  @override
  Stream<MadTabNavigationState> get stateStream;

  @override
  MadTabNavigationState get state;

  /// Handles user interactions with tabs.
  ///
  /// If the tab is the same as the current tab, resets the tab stack for "pop to root" feature.
  /// If the tab is the same and at the root, updates [MadTabNavigationState.isJumpToTopOnRootPage] for "scroll to top" feature.
  void selectTabByUser(MadTabType tab);

  /// Changes the active tab in the navigation state.
  ///
  /// Use this method to programmatically switch to a specific tab in the tab stack.
  /// This method ensures the application displays the active tab without additional
  /// behaviors like popping to the root or scrolling to the top. For those features,
  /// use [selectTabByUser] instead.
  void changeTab(MadTabType tab);

  /// Pushes a new route to the current tab's navigation stack.
  ///
  /// The [route] specifies the route to push, where `T` is the type of result returned
  /// when the route is popped.
  ///
  /// Returns a [Future] that completes with the result of type `T` or `null`
  /// when the pushed route is removed from the stack.
  Future<T?> pushToCurrentTab<T>(NavRoute<T> route);

  /// Replaces an existing route in the current tab's stack with a new route.
  void replaceInTab<T>({
    required NavRoute<T> oldRoute,
    required NavRoute<T> newRoute,
  });

  /// Removes the current route and pushes a new route to the current tab's stack.
  ///
  /// The [route] specifies the route to push, where `T` is the type of result returned
  /// when the route is popped.
  ///
  /// Returns a [Future] that completes with the result of type `T` or `null`
  /// when the pushed route is removed from the stack.
  Future<T?> popAndPushToCurrentTab<T>(NavRoute<T> route);

  /// Pushes a route and removes all previous routes in the current tab until the [predicate] is met.
  ///
  /// The [route] specifies the route to push, where `T` is the type of result returned
  /// when the route is popped. The [predicate] determines which routes to remove.
  ///
  /// Returns a [Future] that completes with the result of type `T` or `null`
  /// when the pushed route is removed from the stack.
  Future<T?> pushAndRemoveUntilForTabStack<T>(
    NavRoute<T> route, {
    required NavRoutePredicate predicate,
  });

  /// Resets the navigation stack for a specific tab.
  ///
  /// The [tab] parameter specifies which tab's stack to reset.
  void resetTabStack(RouteStack stack, {required MadTabType tab});

  /// Resets the "jump to top" flag for the current root page.
  ///
  /// This is used to control the "scroll to top" behavior.
  void resetJumpToTopOnRootPage();
}
