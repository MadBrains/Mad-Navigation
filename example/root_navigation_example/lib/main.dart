import 'package:root_navigation_example/src/app/app.dart';
import 'package:root_navigation_example/src/app/app_root.dart';
import 'package:root_navigation_example/src/data/data.dart';

final NavigationService _navigationService = NavigationServiceImpl();

NavigationService get navigationService => _navigationService;

void main() => runApp(const AppRoot());
