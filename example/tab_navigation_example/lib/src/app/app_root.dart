import 'package:tab_navigation_example/main.dart';
import 'package:tab_navigation_example/src/app/app.dart';

const Color _orange = const Color(0xFFFF5D23);
const Color _purple = const Color(0xFF5D00E2);
const Color _grey = const Color(0xFFD9D9D9);
const Color _white = const Color(0xFFFFFFFF);

class AppRoot extends StatefulWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: AppRouterDelegate<TabNavigationState>(
        navigatorKey: navigatorKey,
        navigationService: navigationService,
        routeMapper: RouteMapper(),
      ),
      routeInformationParser: UrlParser(navigationService),
      themeMode: ThemeMode.light,
      theme: ThemeData.light().copyWith(
        primaryColor: _purple,
        scaffoldBackgroundColor: _grey,
        colorScheme: const ColorScheme.light(primary: _purple),
        listTileTheme: const ListTileThemeData(tileColor: _white),
        tabBarTheme: const TabBarThemeData(
          labelPadding: EdgeInsets.zero,
          labelColor: _orange,
          unselectedLabelColor: _purple,
          indicator: const BoxDecoration(),
          dividerColor: Colors.transparent,
          tabAlignment: TabAlignment.center,
        ),
      ),
    );
  }
}
