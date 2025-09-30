part of 'route_mapper.dart';

/// A builder class that creates Flutter [Page] objects from navigation routes.
///
/// This class handles the conversion of navigation routes to actual Flutter [Page]
/// objects that can be used with the Navigator. It provides default implementations
/// for common page types and allows customization through method overrides.
class MadPageFactoryBuilder {
  /// Creates a [MadPageFactoryBuilder] instance.
  const MadPageFactoryBuilder();

  /// Creates a custom page for an unhandled [NavPage] type.
  ///
  /// Override this method to provide custom page creation logic for specific
  /// [NavPage] types that aren't handled by the default implementation.
  ///
  /// Returns a [Page] if this builder can handle the route, or null otherwise.
  Page<T>? buildCustomPageFromMissingNavPage<T>(
    LocalKey? key,
    NavPage<dynamic> navPage,
    Widget child,
  ) =>
      null;

  /// Creates a custom page for an unhandled [AnyNavRoute] type.
  ///
  /// Override this method to provide custom page creation logic for specific
  /// route types that aren't handled by the default implementation.
  ///
  /// Returns a [Page] if this builder can handle the route, or null otherwise.
  Page<T>? buildCustomPageFromMissingNavRoute<T>(
    LocalKey? key,
    AnyNavRoute navRoute,
    Widget child,
  ) =>
      null;

  /// Creates a [Page] for the given navigation route.
  ///
  /// This is the main entry point for creating pages from navigation routes.
  /// It handles different types of routes (pages, dialogs, bottom sheets) and
  /// delegates to the appropriate builder methods.
  ///
  /// Throws a [MissingPageFactoryException] if no suitable page builder is found.
  Page<T> getPageByRoute<T>({
    required LocalKey? key,
    required AnyNavRoute navRoute,
    required Widget child,
  }) {
    return switch (navRoute) {
      NavPage<dynamic>() => switch (navRoute.type) {
          MaterialPageType() => _MaterialPage<T>(key: key, child: child),
          FadePageType() => _FadeAnimationPage<T>(key: key, child: child),
          SimplePageType() => _SimplePage<T>(key: key, child: child),
          CupertinoPageType() => _CupertinoPage<T>(key: key, child: child),
          (_) => _tryGetCustomPageByRoute(
              key: key, navRoute: navRoute, child: child),
        },
      NavTabHolder<dynamic>() => _SimplePage<T>(key: key, child: child),
      NavDialog<dynamic>() => _Dialog<T>(key: key, child: child),
      NavBottomSheet<dynamic>() => _BottomSheet<T>(key: key, child: child),
      (_) =>
        _tryGetCustomPageByRoute(key: key, navRoute: navRoute, child: child),
    };
  }

  /// Attempts to create a page using custom page builders.
  ///
  /// This method is called when no default page builder is found for a route.
  /// It tries to use custom page builders before throwing an exception.
  ///
  /// Throws a [MissingPageFactoryException] if no suitable page builder is found.
  Page<T> _tryGetCustomPageByRoute<T>({
    required LocalKey? key,
    required AnyNavRoute navRoute,
    required Widget child,
  }) {
    final Page<T>? page;
    if (navRoute is NavPage) {
      page = buildCustomPageFromMissingNavPage(key, navRoute, child);
    } else {
      page = buildCustomPageFromMissingNavRoute(key, navRoute, child);
    }

    if (page == null) throw MissingPageFactoryException(navRoute);

    return page;
  }
}
