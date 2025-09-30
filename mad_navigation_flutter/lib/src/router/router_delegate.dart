import 'package:mad_navigation_flutter/mad_navigation_flutter.dart';
import 'package:flutter/services.dart';

/// A custom [RouterDelegate] implementation for handling navigation in a Flutter app.
///
/// This delegate manages the app's navigation stack and integrates with the
/// Flutter navigation system. It works with [MadNavigationService] to handle
/// route changes and state management.
///
/// Example usage:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return MaterialApp.router(
///     routerDelegate: AppRouterDelegate<NavigationState>(
///       navigatorKey: navigatorKey,
///       navigationService: navigationService,
///       routeMapper: routeMapper,
///     )
///   );
/// }
/// ```
class AppRouterDelegate<S extends MadNavigationState> extends RouterDelegate<S>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<S> {
  /// Creates a new [AppRouterDelegate] with the given parameters.
  AppRouterDelegate({
    required this.navigatorKey,
    required this.navigationService,
    required this.routeMapper,
  });

  /// The navigation service that manages the app's navigation state.
  final MadNavigationService navigationService;

  /// The route mapper that converts navigation routes to pages.
  final MadRouteMapper routeMapper;

  /// Gets the current navigation state.
  S get appState => navigationService.state as S;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  S get currentConfiguration => appState;

  @override
  Widget build(BuildContext context) {
    // Build the list of pages from the current route stack & seed values
    final List<Page<dynamic>> pages = <Page<dynamic>>[
      for (final AnyNavRoute route in appState.routeStack)
        routeMapper.mapRouteToPage<dynamic>(
            route, appState.seed, navigationService),
    ];

    return NavigationListener<S>(
      navigationService: navigationService,
      listener: (BuildContext context, S state, S prevState) {
        notifyListeners();
      },
      upon: (S state) => <Object?>[state.routeStack, state.seed],
      child: BackButtonListener(
        onBackButtonPressed: () async {
          // If we can't pop, exit the app
          if (!navigationService.state.canPop) {
            SystemNavigator.pop();

            return true;
          }

          final NavigatorState? navigatorState = navigatorKey.currentState;

          // Try to pop the current route
          if (navigatorState != null) {
            final bool isPopped = await navigatorState.maybePop();

            if (!isPopped) return isPopped;
          }

          return true;
        },
        child: Navigator(
          key: navigatorKey,
          pages: pages,
          // Use a custom transition delegate to prevent visual jumping by delaying the exit animation
          // until the entering route's animation completes.
          transitionDelegate: const DelayedPopTransitionDelegate(),
          // Handle route removal by Flutter
          onDidRemovePage: (Page<Object?> page) {
            if (!pages.contains(page)) return;

            pages.remove(page);
            navigationService.pop();
          },
        ),
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(S path) async {
    // This method is required but not used in this implementation
    // as the navigation is handled by the navigation service.
  }
}
