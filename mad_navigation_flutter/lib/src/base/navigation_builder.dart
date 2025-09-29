import 'package:mad_navigation_flutter/mad_navigation_flutter.dart';

/// A widget that rebuilds its child when the navigation state changes.
///
/// This widget listens to the provided [navigationService] and rebuilds its
/// child using the [builder] function whenever the navigation state changes.
/// The [upon] parameter can be used to specify which state changes should
/// trigger a rebuild.
class NavigationBuilder<S extends MadNavigationState> extends StatefulWidget {
  /// Creates a [NavigationBuilder] widget.
  const NavigationBuilder({
    super.key,
    required this.navigationService,
    this.upon,
    required this.builder,
  });

  /// The navigation service to listen to.
  final MadNavigationService navigationService;

  /// An optional list of conditions that determine when to rebuild.
  final List<Object?> Function(S state)? upon;

  /// The builder function that creates the widget tree.
  final Widget Function(BuildContext context, S state) builder;

  @override
  State<NavigationBuilder<S>> createState() => _NavigationBuilderState<S>();
}

class _NavigationBuilderState<S extends MadNavigationState> extends State<NavigationBuilder<S>> {
  MadNavigationService get navigationService => widget.navigationService;

  @override
  Widget build(BuildContext context) {
    return NavigationListener<S>(
      navigationService: navigationService,
      upon: widget.upon,
      listener: (BuildContext context, S state, S prevState) => setState(() {}),
      child: widget.builder(context, navigationService.state as S),
    );
  }
}
