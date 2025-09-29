import 'package:root_navigation_example/src/data/data.dart';
import 'package:mad_navigation_impl/mad_navigation_impl.dart';

final class NavigationServiceImpl extends MadNavigationServiceImpl<NavigationState> implements NavigationService {
  NavigationServiceImpl() : super(NavigationState.initial());

  @override
  void login() {
    add(NavigationUpdateStateEvent(state.copyWith(isAuthed: true)));
  }

  @override
  void logout() {
    add(NavigationUpdateStateEvent(NavigationState.initial()));
  }

  @override
  Future<Object?> openPageObjectResultTest() => pushToRoot<Object>(PageObjectResultTest());
}
