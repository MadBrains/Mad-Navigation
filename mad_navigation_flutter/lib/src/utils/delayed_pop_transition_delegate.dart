import 'package:mad_navigation_flutter/mad_navigation_flutter.dart';

/// A custom [TransitionDelegate] that delays the completion of pop transitions.
///
/// This delegate provides a smoother user experience by waiting for the
/// entering route's animation to complete before starting the exiting route's
/// animation during a pop operation. This prevents the "jumping" effect that
/// can occur with the default transition behavior.
///
/// The delegate handles both single and bulk pop operations, and works with
/// both page-based and pageless routes.
class DelayedPopTransitionDelegate extends TransitionDelegate<void> {
  const DelayedPopTransitionDelegate();

  @override
  Iterable<RouteTransitionRecord> resolve({
    required List<RouteTransitionRecord> newPageRouteHistory,
    required Map<RouteTransitionRecord?, RouteTransitionRecord>
        locationToExitingPageRoute,
    required Map<RouteTransitionRecord?, List<RouteTransitionRecord>>
        pageRouteToPagelessRoutes,
  }) {
    final List<RouteTransitionRecord> results = <RouteTransitionRecord>[];

    // Determining if it's a mass pop.
    final int numberOfExitingRoutes = locationToExitingPageRoute.length;
    final bool isBulkPop = numberOfExitingRoutes > 1;

    // This method will handle the exiting route and its corresponding pageless
    // route at this location. It will also recursively check if there is any
    // other exiting routes above it and handle them accordingly.
    void handleExitingRoute(RouteTransitionRecord? location,
        {required bool isLast}) {
      final RouteTransitionRecord? exitingPageRoute =
          locationToExitingPageRoute[location];
      if (exitingPageRoute == null) return;

      if (exitingPageRoute.isWaitingForExitingDecision) {
        final bool hasPagelessRoute =
            pageRouteToPagelessRoutes.containsKey(exitingPageRoute);
        final bool isLastExitingPageRoute =
            isLast && !locationToExitingPageRoute.containsKey(exitingPageRoute);
        if (isBulkPop || isLastExitingPageRoute) {
          exitingPageRoute.markForPop(exitingPageRoute.route.currentResult);
        } else {
          exitingPageRoute
              .markForComplete(exitingPageRoute.route.currentResult);
        }

        if (hasPagelessRoute) {
          final List<RouteTransitionRecord> pagelessRoutes =
              pageRouteToPagelessRoutes[exitingPageRoute] ??
                  const <RouteTransitionRecord>[];
          for (final RouteTransitionRecord pagelessRoute in pagelessRoutes) {
            // It is possible that a pageless route that belongs to an exiting
            // page-based route does not require exiting decision. This can
            // happen if the page list is updated right after a Navigator.pop.
            if (pagelessRoute.isWaitingForExitingDecision) {
              if (isBulkPop ||
                  isLastExitingPageRoute &&
                      pagelessRoute == pagelessRoutes.last) {
                pagelessRoute.markForPop(pagelessRoute.route.currentResult);
              } else {
                pagelessRoute
                    .markForComplete(pagelessRoute.route.currentResult);
              }
            }
          }
        }
      }

      results.add(exitingPageRoute);

      // It is possible there is another exiting route above this exitingPageRoute.
      handleExitingRoute(exitingPageRoute, isLast: isLast);
    }

    // Handles exiting route in the beginning of list.
    handleExitingRoute(null, isLast: newPageRouteHistory.isEmpty);

    for (final RouteTransitionRecord pageRoute in newPageRouteHistory) {
      final bool isLastIteration = newPageRouteHistory.last == pageRoute;

      if (pageRoute.isWaitingForEnteringDecision) {
        if (!locationToExitingPageRoute.containsKey(pageRoute) &&
            isLastIteration) {
          pageRoute.markForPush();
        } else {
          pageRoute.markForAdd();
        }
      }

      results.add(pageRoute);
      handleExitingRoute(pageRoute, isLast: isLastIteration);
    }

    return results;
  }
}
