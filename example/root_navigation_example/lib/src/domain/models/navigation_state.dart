import 'package:mad_navigation/mad_navigation.dart';

part 'nav_routes.dart';

part 'nav_route_args.dart';

part 'navigation_models.dart';

final class NavigationState extends MadNavigationState {
  NavigationState({
    required super.rootStack,
    required super.seed,
    required super.pageUnknownOpen,
    required super.lastResult,
    required this.isAuthed,
  });

  NavigationState.initial()
      : this(
          rootStack: <AnyNavRoute>{PageNavMethodsTest<void>(0)},
          seed: null,
          pageUnknownOpen: false,
          lastResult: null,
          isAuthed: false,
        );

  final bool isAuthed;

  @override
  RouteStack formRouteStack() {
    if (!isAuthed) {
      return <AnyNavRoute>{PageLoginTest()};
    }

    return super.formRouteStack();
  }

  @override
  NavigationState copyWith({
    RouteStack? rootStack,
    Nullable<String?>? seed,
    bool? pageUnknownOpen,
    Nullable<Object?>? lastResult,
    bool? isAuthed,
  }) =>
      NavigationState(
        rootStack: rootStack ?? this.rootStack,
        seed: seed?.value ?? this.seed,
        pageUnknownOpen: pageUnknownOpen ?? this.pageUnknownOpen,
        lastResult: lastResult?.value ?? this.lastResult,
        isAuthed: isAuthed ?? this.isAuthed,
      );

  @override
  List<Object?> get props => <Object?>[...super.props, isAuthed];

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{...super.mappedFields, 'isAuthed': isAuthed};
}
