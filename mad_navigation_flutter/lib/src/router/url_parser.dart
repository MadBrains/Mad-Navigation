import 'package:mad_navigation_flutter/mad_navigation_flutter.dart';

/// An abstract base class for parsing and restoring URL routes in a Flutter application.
///
/// This class provides a foundation for implementing custom URL parsing logic
/// that integrates with the app's navigation system. It works in conjunction with
/// [MadNavigationService] to maintain the application state based on the URL.
///
/// Subclasses should implement [restoreRouteInformation] to provide custom
/// URL generation logic, and may override [parseRouteInformation] for custom
/// URL parsing if needed.
abstract class MadUrlParser extends RouteInformationParser<MadNavigationState> {
  /// Creates a new [MadUrlParser] with the given [navigationService].
  const MadUrlParser(this.navigationService);

  /// The navigation service used to access the current app state.
  final MadNavigationService navigationService;

  /// Parses the given [info] into a [MadNavigationState].
  ///
  /// This implementation returns the current navigation state without modification.
  /// Subclasses can override this method to provide custom URL parsing logic.
  @override
  Future<MadNavigationState> parseRouteInformation(
      RouteInformation info) async {
    final MadNavigationState initial = navigationService.state;

    // TODO(FD-94): parse full route location for flutter web

    return initial;
  }

  /// Restores route information from the given [state].
  ///
  /// Subclasses must implement this method to convert the navigation state
  /// back into a [RouteInformation] object that can be used to update the URL.
  @override
  RouteInformation restoreRouteInformation(MadNavigationState state);
}
