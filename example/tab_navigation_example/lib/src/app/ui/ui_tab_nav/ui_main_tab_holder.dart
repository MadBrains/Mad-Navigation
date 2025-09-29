import 'package:tab_navigation_example/main.dart';
import 'package:tab_navigation_example/src/app/app.dart';

part 'tab_bar.dart';

class UiMainTabHolder extends StatefulWidget {
  const UiMainTabHolder({super.key});

  @override
  _UiMainTabHolderState createState() => _UiMainTabHolderState();
}

class _UiMainTabHolderState extends State<UiMainTabHolder> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Router<dynamic>(
        backButtonDispatcher: Router.of(context).backButtonDispatcher,
        routerDelegate: TabRouterDelegate<TabNavigationState>(
          navigatorKey: navigatorKey,
          navigationService: navigationService,
          routeMapper: RouteMapper(),
        ),
      ),
      bottomNavigationBar: AppTabBar(navigationService: navigationService),
    );
  }
}
