part of 'mad_navigation_service_impl.dart';

/// Base class for all navigation events in the Navigation system.
///
/// All navigation-related events should extend this class to be processed
/// by the navigation service.
abstract class MadNavigationEvent {
  const MadNavigationEvent();
}

/// Event to push a new root route onto the navigation stack.
///
/// This will add the [route] to the top of the navigation stack.
final class NavigationPushRootRouteEvent extends MadNavigationEvent
    with Stringify {
  const NavigationPushRootRouteEvent(this.route);

  /// The route to push onto the stack.
  final AnyNavRoute route;

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{'route': route};
}

/// Event to refresh the current navigation state.
///
/// This can be used to force a UI update without changing the navigation stack.
final class NavigationRefreshEvent extends MadNavigationEvent {
  const NavigationRefreshEvent();
}

/// Event to replace a specific route in the navigation stack.
///
/// This will replace [oldRoute] with [newRoute] in the navigation stack.
final class NavigationReplaceRootRouteEvent extends MadNavigationEvent
    with Stringify {
  const NavigationReplaceRootRouteEvent({
    required this.oldRoute,
    required this.newRoute,
  });

  /// The route to be replaced.
  final AnyNavRoute oldRoute;

  /// The new route to replace with.
  final AnyNavRoute newRoute;

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{
        'oldRoute': oldRoute,
        'newRoute': newRoute,
      };
}

/// Event to update the entire navigation state.
///
/// This will replace the current navigation state with the provided [state].
final class NavigationUpdateStateEvent extends MadNavigationEvent
    with Stringify {
  const NavigationUpdateStateEvent(this.state);

  /// The new navigation state.
  final MadNavigationState state;

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{'state': state};
}

/// Event to pop the current route from the navigation stack.
///
/// Optionally provides a [result] that will be returned to the previous route.
final class NavigationPopEvent extends MadNavigationEvent with Stringify {
  const NavigationPopEvent({this.result});

  /// The result to return to the previous route.
  final Object? result;

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{'result': result};
}

/// Event to pop the current route and push a new root route.
///
/// This combines a pop and push operation into a single atomic action.
final class NavigationPopAndPushRootRouteEvent extends MadNavigationEvent
    with Stringify {
  const NavigationPopAndPushRootRouteEvent(this.route, {this.result});

  /// The new route to push.
  final AnyNavRoute route;

  /// The result to return to the previous route.
  final Object? result;

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{
        'route': route,
        'result': result,
      };
}

/// Event to pop routes until a certain condition is met.
///
/// The [predicate] determines which route to pop until.
final class NavigationPopUntilEvent extends MadNavigationEvent with Stringify {
  const NavigationPopUntilEvent(this.predicate);

  /// The predicate that determines when to stop popping routes.
  final NavRoutePredicate predicate;

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{
        'predicate': predicate,
      };
}

/// Event to push a new route and remove all routes until a condition is met.
///
/// This is commonly used for navigation flows where you want to clear the stack
/// up to a certain point and then push a new route.
final class NavigationPushAndRemoveUntilForRootStackEvent
    extends MadNavigationEvent with Stringify {
  const NavigationPushAndRemoveUntilForRootStackEvent({
    required this.route,
    required this.predicate,
  });

  /// The new route to push.
  final AnyNavRoute route;

  /// The predicate that determines which routes to remove.
  final NavRoutePredicate predicate;

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{
        'route': route,
        'predicate': predicate,
      };
}

/// Event to completely reset the navigation stack.
///
/// This will replace the entire navigation stack with the provided [stack].
final class NavigationResetRootStackEvent extends MadNavigationEvent
    with Stringify {
  const NavigationResetRootStackEvent(this.stack);

  /// The new navigation stack.
  final RouteStack stack;

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{'stack': stack};
}
