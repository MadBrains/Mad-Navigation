import 'package:mad_navigation_flutter/mad_navigation_flutter.dart';

/// A custom [RouterDelegate] implementation for handling tab-based navigation in a Flutter app.
///
/// This delegate manages the navigation stack for a specific tab in a tab-based navigation system.
/// It works with [MadTabNavigationService] to handle route changes and state management
/// within a single tab's navigation stack.
///
/// Example usage:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: Router<dynamic>(
///       routerDelegate: TabRouterDelegate<TabNavigationState>(
///         navigatorKey: navigatorKey,
///         navigationService: navigationService,
///         routeMapper: routeMapper,
///       ),
///     ),
///   );
/// }
/// ```
class TabRouterDelegate<S extends MadTabNavigationState>
    extends RouterDelegate<S>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<S> {
  /// Creates a new [TabRouterDelegate] with the given parameters.
  TabRouterDelegate({
    required this.navigatorKey,
    required this.navigationService,
    required this.routeMapper,
  });

  /// The tab navigation service that manages this tab's navigation state.
  final MadTabNavigationService navigationService;

  /// The route mapper that converts navigation routes to pages.
  final MadRouteMapper routeMapper;

  /// Gets the current tab navigation state.
  S get appState => navigationService.state as S;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  S get currentConfiguration => appState;

  @override
  Widget build(BuildContext context) {
    // Build the list of pages from the current tab's route stack & seed values
    final List<Page<dynamic>> pages = <Page<dynamic>>[
      for (final AnyNavRoute route in appState.mergedTabStack)
        routeMapper.mapRouteToPage<dynamic>(
            route, appState.seed, navigationService),
    ];

    return NavigationListener<S>(
      navigationService: navigationService,
      listener: (BuildContext context, S state, S prevState) {
        notifyListeners();
      },
      upon: (S state) => <Object?>[state.mergedTabStack, state.seed],
      child: BackButtonListener(
        onBackButtonPressed: () async {
          // Only handle back if there are routes to pop
          if (!navigationService.state.canPop) return false;

          final NavigatorState? navigatorState = navigatorKey.currentState;

          // Only pop if this tab is currently active
          if (navigatorState != null && navigationService.state.tabIsActive) {
            return navigatorState.maybePop();
          }

          return false;
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
    // This method is intentionally left empty as the tab router delegate
    // doesn't handle route parsing directly. Navigation is managed by the
    // tab navigation service.
    assert(false, 'setNewRoutePath should not be called on TabRouterDelegate');
  }
}
