part of 'mad_tab_navigation_service_impl.dart';

/// Event triggered when a user manually selects a tab.
///
/// Fired in response to user interaction with the tab bar, this event handles
/// tab selection. If the selected tab is already active, it pops the tab's
/// navigation stack to the root and scrolls to the top of the root page.
final class NavigationSelectTabByUserEvent extends MadNavigationEvent with Stringify {
  const NavigationSelectTabByUserEvent(this.tab);

  /// The tab that was selected by the user
  final MadTabType tab;

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{'tab': tab};
}

/// Event to programmatically change the current tab.
///
/// Unlike [NavigationSelectTabByUserEvent], this is used for programmatic
/// tab changes rather than direct user interaction.
final class NavigationChangeTabEvent extends MadNavigationEvent with Stringify {
  const NavigationChangeTabEvent(this.tab);

  /// The tab to switch to
  final MadTabType tab;

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{'tab': tab};
}

/// Event to push a new route onto the current tab's navigation stack.
///
/// This adds a new route to the top of the current tab's navigation stack.
final class NavigationPushTabRouteEvent extends MadNavigationEvent with Stringify {
  const NavigationPushTabRouteEvent(this.route);

  /// The route to push onto the tab's navigation stack
  final AnyNavRoute route;

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{'route': route};
}

/// Event to replace a route in the current tab's navigation stack.
///
/// This replaces an existing route with a new one, maintaining the same
/// position in the navigation stack.
final class NavigationReplaceTabRouteEvent extends MadNavigationEvent with Stringify {
  const NavigationReplaceTabRouteEvent({
    required this.oldRoute,
    required this.newRoute,
  });

  /// The route to be replaced
  final AnyNavRoute oldRoute;

  /// The new route to replace with
  final AnyNavRoute newRoute;

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{
        'oldRoute': oldRoute,
        'newRoute': newRoute,
      };
}

/// Event to pop the current route and push a new route in the current tab.
///
/// This combines a pop and push operation into a single atomic action.
final class NavigationPopAndPushTabRouteEvent extends MadNavigationEvent with Stringify {
  const NavigationPopAndPushTabRouteEvent(this.route, {this.result});

  /// The new route to push
  final AnyNavRoute route;

  /// Optional result to be returned to the previous route
  final Object? result;

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{
        'route': route,
        'result': result,
      };
}

/// Event to push a new route and remove all routes until a condition is met.
///
/// This is commonly used for navigation flows where you want to clear the stack
/// up to a certain point and then push a new route in the current tab.
final class NavigationPushAndRemoveUntilForTabStackEvent extends MadNavigationEvent with Stringify {
  const NavigationPushAndRemoveUntilForTabStackEvent({required this.route, required this.predicate});

  /// The new route to push
  final AnyNavRoute route;

  /// The predicate that determines which routes to remove
  final NavRoutePredicate predicate;

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{
        'route': route,
        'predicate': predicate,
      };
}

/// Event to completely reset a tab's navigation stack.
///
/// This replaces the entire navigation stack for the specified tab with a new one.
final class NavigationResetTabStackEvent extends MadNavigationEvent with Stringify {
  const NavigationResetTabStackEvent({
    required this.tab,
    required this.stack,
  });

  /// The tab whose stack should be reset
  final MadTabType tab;

  /// The new navigation stack for the tab
  final RouteStack stack;

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{
        'tab': tab,
        'stack': stack,
      };
}

/// Event to reset the "jump to top" behavior for the root page.
///
/// This is used to control the scroll-to-top behavior when a tab is reselected.
final class NavigationResetJumpToTopOnRootPageEvent extends MadNavigationEvent {
  const NavigationResetJumpToTopOnRootPageEvent();
}
