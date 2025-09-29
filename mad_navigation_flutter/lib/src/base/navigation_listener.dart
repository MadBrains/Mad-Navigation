import 'dart:async';

import 'package:mad_navigation_flutter/mad_navigation_flutter.dart';

/// Signature for the listener callback used by [NavigationListener].
///
/// The function is called with the current [BuildContext], the new [state],
/// and the previous [prevState] whenever the navigation state changes.
typedef FlutterBlocListener<S> = void Function(
  BuildContext context,
  S state,
  S prevState,
);

/// A widget that listens to navigation state changes and calls [listener] in response.
///
/// This widget doesn't rebuild its child when the navigation state changes,
/// but instead calls the [listener] callback. The [upon] parameter can be
/// used to filter which state changes should trigger the listener.
class NavigationListener<S extends MadNavigationState> extends StatefulWidget {
  /// Creates a [NavigationListener] widget.
  const NavigationListener({
    super.key,
    required this.navigationService,
    this.upon,
    required this.listener,
    required this.child,
  });

  /// The navigation service to listen to.
  final MadNavigationService navigationService;

  /// An optional condition that determines when to call the [listener].
  final MadBlocUponCondition<S>? upon;

  /// The callback to be called when the navigation state changes.
  final FlutterBlocListener<S> listener;

  /// The child widget to display.
  final Widget child;

  @override
  State<NavigationListener<S>> createState() => _NavigationListenerState<S>();
}

class _NavigationListenerState<S extends MadNavigationState> extends State<NavigationListener<S>> {
  late final StreamSubscription<S> _subscription;

  S? _prevState;

  MadNavigationService get navigationService => widget.navigationService;

  @override
  void initState() {
    super.initState();
    _subscription = navigationService.stateStream.cast<S>().listen(_listener);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _listener(S state) {
    final S? prevState = _prevState;
    final MadBlocListenerCondition<S>? listenWhen = widget.upon?.form();

    if (prevState == null) {
      widget.listener(context, state, state);
    } else if (listenWhen != null) {
      final bool isUpdated = listenWhen(prevState, state);

      if (isUpdated) {
        widget.listener(context, state, prevState);
      }
    }

    _prevState = state;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
