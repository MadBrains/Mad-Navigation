import 'package:mad_navigation/mad_navigation.dart';

/// Base class for all navigation-related exceptions in the `mad_navigation` package.
///
/// All custom exceptions thrown by the navigation system should extend this class.
abstract class MadNavigationException implements Exception {
  const MadNavigationException();
}

/// Exception thrown when no page factory is found for a navigation route.
///
/// This occurs when the navigation system attempts to create a [Page] for a given
/// [AnyNavRoute], but no corresponding page factory is registered in the
/// [MadPageFactoryBuilder]. This typically happens when a custom route or page type
/// is used without providing a page builder implementation.
class MissingPageFactoryException extends MadNavigationException {
  const MissingPageFactoryException(this.route);

  /// The route for which no page factory was found.
  final AnyNavRoute route;

  @override
  String toString() => 'MissingPageFactoryException: No page factory found for $route';
}

/// Exception thrown when no route handler is found for a navigation action.
///
/// This is a more general exception than [MissingPageFactoryException] and
/// indicates that the navigation system doesn't know how to handle the
/// specified route at all. This typically happens when trying to navigate to
/// a route that hasn't been properly registered in the navigation system.
class UnhandledRouteException extends MadNavigationException {
  const UnhandledRouteException(this.route);

  /// The route that has no registered handler.
  final AnyNavRoute route;

  @override
  String toString() => 'UnhandledRouteException: No handler found for $route';
}

/// Exception thrown when attempting to register a duplicate route type.
///
/// This occurs when trying to register a route type that has already been
/// registered in the navigation system. Each route type must be unique.
class DuplicateRouteException extends MadNavigationException {
  const DuplicateRouteException(this.type);

  /// The type of the duplicate route.
  final Type type;

  @override
  String toString() => 'DuplicateRouteException: Route with type $type already exists';
}
