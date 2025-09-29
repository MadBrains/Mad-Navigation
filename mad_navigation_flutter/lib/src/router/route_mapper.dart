import 'package:mad_navigation_flutter/mad_navigation_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';

part 'pages.dart';

part 'page_factory_builder.dart';

/// A base class for mapping navigation routes to Flutter pages.
///
/// This class handles the conversion of navigation routes to Flutter [Page] objects
/// and manages the widget builders for different route types. It provides a type-safe
/// way to map navigation routes to their corresponding UI components.
///
/// Subclasses should implement the [routers] getter to provide the route mappings.
///
/// Example usage:
/// ```dart
/// class AppRouteMapper extends MadRouteMapper {
///   @override
///   final List<MadNavMapper<AnyNavRoute>> routers = [
///     PageMapper(routes),
///     TabHolderMapper(routes),
///     DialogMapper(routes),
///     BottomSheetMapper(routes),
///   ];
/// }
/// ```
abstract class MadRouteMapper {
  /// Creates a new [MadRouteMapper] with an optional custom [pageBuilder].
  ///
  /// If no [pageBuilder] is provided, a default [MadPageFactoryBuilder] will be used.
  MadRouteMapper({MadPageFactoryBuilder? pageBuilder}) : _pageBuilder = pageBuilder ?? const MadPageFactoryBuilder() {
    _prepareRoutes();
  }

  /// The list of route mappers that define the application's navigation structure.
  ///
  /// Each mapper in this list provides a set of route builders for specific
  /// navigation routes.
  abstract final List<MadNavMapper<AnyNavRoute>> routers;

  final MadPageFactoryBuilder _pageBuilder;

  final Set<MadRouteBuilder<AnyNavRoute>> _routes = <MadRouteBuilder<AnyNavRoute>>{};

  /// Returns the set of all registered route builders.
  Set<MadRouteBuilder<AnyNavRoute>> get routes => _routes;

  /// Converts a navigation route to a Flutter [Page].
  ///
  /// This method takes a navigation route, an optional [seed] for key generation,
  /// and a [navigationService], then returns a corresponding [Page] object.
  ///
  /// Throws [UnhandledRouteException] if no builder is found for the route.
  Page<T> mapRouteToPage<T>(
    AnyNavRoute navRoute,
    String? seed,
    MadNavigationService navigationService,
  ) =>
      _pageBuilder.getPageByRoute(
        key: _getKey(navRoute, seed),
        navRoute: navRoute,
        child: _build(navRoute),
      );

  /// Generates a [LocalKey] for the given [navRoute] and [seed].
  ///
  /// The key is created using the route's [pageKey] and the provided [seed].
  LocalKey? _getKey(AnyNavRoute navRoute, String? seed) => ValueKey<String>('${navRoute.pageKey}?$seed');

  /// Builds a widget for the given [route] using the appropriate route builder.
  ///
  /// Throws [UnhandledRouteException] if no builder is found for the route.
  Widget _build(AnyNavRoute route) {
    final MadRouteBuilder<AnyNavRoute>? builder =
        _routes.firstWhereOrNull((MadRouteBuilder<AnyNavRoute> builder) => builder.canHandle(route));

    if (builder == null) throw UnhandledRouteException(route);

    return builder(route);
  }

  /// Prepares the route builders by collecting them from all registered routers.
  ///
  /// Throws [DuplicateRouteException] if multiple builders are registered for
  /// the same route type.
  void _prepareRoutes() {
    for (final MadNavMapper<dynamic> router in routers) {
      for (final MadRouteBuilder<dynamic> route in router.routes) {
        final Type type = route.type;
        if (_routes.containsType(type)) throw DuplicateRouteException(type);
        _routes.add(route as MadRouteBuilder<AnyNavRoute>);
      }
    }
  }
}

extension on Set<MadRouteBuilder<AnyNavRoute>> {
  /// Checks if this set of routes contains a builder for the given [type].
  bool containsType(Type type) => any((MadRouteBuilder<AnyNavRoute> builder) => builder.type == type);
}
