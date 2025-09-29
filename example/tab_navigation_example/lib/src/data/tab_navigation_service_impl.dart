import 'package:tab_navigation_example/src/data/data.dart';
import 'package:mad_navigation_impl/mad_navigation_impl.dart';

final class TabNavigationServiceImpl extends MadTabNavigationServiceImpl<TabNavigationState>
    implements TabNavigationService {
  TabNavigationServiceImpl() : super(TabNavigationState.initial());

  @override
  void login() {
    add(NavigationUpdateStateEvent(state.copyWith(isAuthed: true)));
  }

  void logout() {
    add(NavigationUpdateStateEvent(TabNavigationState.initial()));
  }

  @override
  Future<Object?> openPageObjectResultTest() => pushToCurrentTab<Object>(PageObjectResultTest());
}
