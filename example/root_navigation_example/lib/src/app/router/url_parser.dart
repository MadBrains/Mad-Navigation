import 'package:mad_navigation_flutter/mad_navigation_flutter.dart';

class UrlParser extends MadUrlParser {
  const UrlParser(MadNavigationService navigationService) : super(navigationService);

  @override
  RouteInformation restoreRouteInformation(MadNavigationState state) {
    return RouteInformation(uri: Uri(path: state.rootStack.getLocation()));
  }
}
