import 'package:mad_navigation_flutter/mad_navigation_flutter.dart';

/// A builder class that creates widgets for specific types of navigation routes.
///
/// This class is used to define how different types of navigation routes should be
/// transformed into widgets. It provides type safety by ensuring that each builder
/// only handles routes of a specific type [T] that extends [AnyNavRoute].
///
/// Example usage:
/// ```dart
/// final class MyCustomRoute extends AnyNavRoute {}
///
/// final routeBuilder = MadRouteBuilder<MyCustomRoute>(
///   (route) => MyCustomPage(route: route),
/// );
/// ```
class MadRouteBuilder<T extends AnyNavRoute> {
  /// Creates a route builder with the given [builder] function and type [T].
  const MadRouteBuilder(this.builder) : type = T;

  /// The type of route this builder can handle.
  final Type type;

  /// The builder function that creates a widget for a given route.
  final Widget Function(T route) builder;

  /// Checks if this builder can handle the given [route].
  ///
  /// Returns `true` if the route is of type [T], `false` otherwise.
  bool canHandle(AnyNavRoute route) => route is T;

  /// Calls the builder function with the given [route].
  Widget call(T route) => builder(route);
}
