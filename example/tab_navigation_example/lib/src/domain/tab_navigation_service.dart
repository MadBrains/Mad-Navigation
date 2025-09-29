import 'package:tab_navigation_example/src/domain/domain.dart';
import 'package:mad_navigation/mad_navigation.dart';

abstract class TabNavigationService implements MadTabNavigationService {
  @override
  TabNavigationState get state;

  void login();

  void logout();

  Future<Object?> openPageObjectResultTest();
}
