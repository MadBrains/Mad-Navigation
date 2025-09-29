import 'package:mad_navigation/mad_navigation.dart';
import 'package:root_navigation_example/src/domain/domain.dart';

abstract class NavigationService implements MadNavigationService {
  @override
  NavigationState get state;

  void login();

  void logout();

  Future<Object?> openPageObjectResultTest();
}
