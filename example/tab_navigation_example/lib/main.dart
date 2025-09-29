import 'package:tab_navigation_example/src/app/app.dart';
import 'package:tab_navigation_example/src/app/app_root.dart';
import 'package:tab_navigation_example/src/data/data.dart';

final TabNavigationService _navigationService = TabNavigationServiceImpl();

TabNavigationService get navigationService => _navigationService;

void main() => runApp(const AppRoot());
