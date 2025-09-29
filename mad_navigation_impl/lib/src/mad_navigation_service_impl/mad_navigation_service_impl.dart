import 'package:mad_navigation_impl/mad_navigation_impl.dart';
import 'package:mad_navigation_impl/src/basic_bloc.dart';
import 'package:uuid/uuid.dart';

part 'mad_navigation_event.dart';

part 'mad_navigation_service_mixin.dart';

part 'mad_navigation_state_actions.dart';

/// Core implementation of [MadNavigationService] for root stack navigation.
///
/// Manages the main navigation stack and handles basic navigation operations.
class MadNavigationServiceImpl<T extends MadNavigationState>
    extends BasicBloc<MadNavigationEvent, MadNavigationState>
    with _NavigatorBlocMixin
    implements MadNavigationService {
  /// Creates a new [MadNavigationServiceImpl] with the given [initialState].
  MadNavigationServiceImpl(T initialState) : super(initialState);

  @override
  T get state => super.state as T;

  @override
  void setEventHandlers() {
    onAsync<NavigationPushRootRouteEvent>((
      NavigationPushRootRouteEvent event,
    ) async* {
      yield state._pushToRootStack(event.route);
    });
    onAsync<NavigationRefreshEvent>((NavigationRefreshEvent event) async* {
      yield state.copyWith(seed: const Uuid().v1().nullable());
    });
    onAsync<NavigationUpdateStateEvent>((
      NavigationUpdateStateEvent event,
    ) async* {
      yield event.state;
    });
    onAsync<NavigationPopEvent>((NavigationPopEvent event) async* {
      yield state._pop(lastResult: event.result);
    });
    onAsync<NavigationPopAndPushRootRouteEvent>((
      NavigationPopAndPushRootRouteEvent event,
    ) async* {
      yield state._popAndPushRootStack(event.route, lastResult: event.result);
    });
    onAsync<NavigationPopUntilEvent>((NavigationPopUntilEvent event) async* {
      yield state._popUntil(event.predicate);
    });
    onAsync<NavigationReplaceRootRouteEvent>((
      NavigationReplaceRootRouteEvent event,
    ) async* {
      yield state._replaceInRootStack(
        oldPage: event.oldRoute,
        newPage: event.newRoute,
      );
    });
    onAsync<NavigationPushAndRemoveUntilForRootStackEvent>((
      NavigationPushAndRemoveUntilForRootStackEvent event,
    ) async* {
      yield state._pushAndRemoveUntilForRootStack(event.route, event.predicate);
    });
    onAsync<NavigationResetRootStackEvent>((
      NavigationResetRootStackEvent event,
    ) async* {
      yield state.copyWith(rootStack: event.stack);
    });
  }
}
