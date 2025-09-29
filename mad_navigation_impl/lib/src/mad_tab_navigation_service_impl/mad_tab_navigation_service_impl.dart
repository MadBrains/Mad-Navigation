import 'package:mad_navigation_impl/mad_navigation_impl.dart';
import 'package:mad_navigation_impl/src/basic_bloc.dart';

part 'mad_tab_navigation_event.dart';

part 'mad_tab_navigation_service_mixin.dart';

part 'mad_tab_navigation_state_actions.dart';

/// Extends [MadNavigationServiceImpl] with tab-based navigation support.
///
/// Manages multiple independent navigation stacks for tabbed interfaces.
class MadTabNavigationServiceImpl<T extends MadTabNavigationState>
    extends MadNavigationServiceImpl<T> with _TabNavigatorBlocMixin {
  /// Creates a new [MadTabNavigationServiceImpl] with the given [initialState].
  MadTabNavigationServiceImpl(T initialState) : super(initialState);

  @override
  void setEventHandlers() {
    onAsync<NavigationSelectTabByUserEvent>((
      NavigationSelectTabByUserEvent event,
    ) async* {
      final MadTabType newTab = event.tab;
      if (newTab == state.activeTab) {
        yield state._popToRootPageInTab(newTab, state.getPageByTab(newTab));
      } else {
        yield state._changeTab(newTab);
      }
    });
    onAsync<NavigationChangeTabEvent>((NavigationChangeTabEvent event) async* {
      if (event.tab != state.activeTab) {
        yield state._changeTab(event.tab);
      }
    });
    onAsync<NavigationPushTabRouteEvent>((
      NavigationPushTabRouteEvent event,
    ) async* {
      yield state._pushToTabStack(event.route);
    });
    onAsync<NavigationPopEvent>((NavigationPopEvent event) async* {
      yield state._pop(lastResult: event.result);
    });
    onAsync<NavigationPopAndPushTabRouteEvent>((
      NavigationPopAndPushTabRouteEvent event,
    ) async* {
      yield state._popAndPushTabStack(event.route, lastResult: event.result);
    });
    onAsync<NavigationPopUntilEvent>((NavigationPopUntilEvent event) async* {
      yield state._popUntil(event.predicate);
    });
    onAsync<NavigationReplaceTabRouteEvent>((
      NavigationReplaceTabRouteEvent event,
    ) async* {
      yield state._replaceInTabStack(
        oldPage: event.oldRoute,
        newPage: event.newRoute,
      );
    });
    onAsync<NavigationPushAndRemoveUntilForTabStackEvent>((
      NavigationPushAndRemoveUntilForTabStackEvent event,
    ) async* {
      yield state._pushAndRemoveUntilForTabStack(event.route, event.predicate);
    });
    onAsync<NavigationResetTabStackEvent>((
      NavigationResetTabStackEvent event,
    ) async* {
      yield state._saveTabStack(event.tab, event.stack);
    });
    onAsync<NavigationResetJumpToTopOnRootPageEvent>((
      NavigationResetJumpToTopOnRootPageEvent event,
    ) async* {
      yield state.copyWith(isJumpToTopOnRootPage: false);
    });

    super.setEventHandlers();
  }
}
