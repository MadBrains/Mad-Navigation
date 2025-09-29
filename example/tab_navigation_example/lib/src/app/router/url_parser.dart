import 'package:tab_navigation_example/src/app/app.dart';

class UrlParser extends MadUrlParser {
  const UrlParser(MadNavigationService navigationService) : super(navigationService);

  @override
  RouteInformation restoreRouteInformation(MadNavigationState state) {
    late final AnyNavRoute lastRoute = state.routeStack.last;

    if (state is TabNavigationState && lastRoute is MainTabHolder) {
      return RouteInformation(uri: Uri(path: state.selectedStack.getLocation(state.activeTab.name)));
    }

    return RouteInformation(uri: Uri(path: state.rootStack.getLocation()));
  }
}
