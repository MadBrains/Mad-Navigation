import 'package:mad_navigation/mad_navigation.dart';

part 'nav_route_args.dart';
part 'nav_routes.dart';
part 'navigation_models.dart';
part 'tab_type.dart';

final class TabNavigationState extends MadTabNavigationState {
  TabNavigationState({
    required super.rootStack,
    required super.seed,
    required super.pageUnknownOpen,
    required super.lastResult,
    required super.tabs,
    required super.activeTab,
    required super.activeTabs,
    required super.tabStacks,
    required super.isJumpToTopOnRootPage,
    required this.isAuthed,
  });

  TabNavigationState.initial()
      : this(
          rootStack: <AnyNavRoute>{MainTabHolder()},
          seed: null,
          pageUnknownOpen: false,
          lastResult: null,
          tabs: _tabs,
          activeTab: _tabs.first,
          activeTabs: <MadTabType>{_tabs.first},
          tabStacks: _tabs.map((MadTabType tab) => <AnyNavRoute>{_getPageByTab(tab)}).toList(growable: false),
          isJumpToTopOnRootPage: false,
          isAuthed: false,
        );

  final bool isAuthed;

  static const List<MadTabType> _tabs = <MadTabType>[
    const CounterTabType(),
    const NavMethodsTabType(),
    const ScrollableContentTabType(),
    const ProfileTabType(),
  ];

  static NavPage<dynamic> _getPageByTab(TabType tab) => switch (tab) {
        CounterTabType() => PageCounterTest(const PageCounterTestArgs(id: 0)),
        NavMethodsTabType() => PageNavMethodsTest<void>(0),
        ScrollableContentTabType() => PageScrollToTopTest(),
        ProfileTabType() => PageProfileTest(),
        (_) => throw UnimplementedError(),
      };

  @override
  RouteStack formRouteStack() {
    if (!isAuthed) {
      return <AnyNavRoute>{PageLoginTest()};
    }

    return super.formRouteStack();
  }

  @override
  NavPage<dynamic> getPageByTab(TabType tab) => _getPageByTab(tab);

  @override
  TabNavigationState copyWith({
    RouteStack? rootStack,
    Nullable<String?>? seed,
    bool? pageUnknownOpen,
    Nullable<Object?>? lastResult,
    List<MadTabType>? tabs,
    MadTabType? activeTab,
    Set<MadTabType>? activeTabs,
    List<Set<AnyNavRoute>>? tabStacks,
    bool? isJumpToTopOnRootPage,
    bool? isAuthed,
  }) =>
      TabNavigationState(
        rootStack: rootStack ?? this.rootStack,
        seed: seed?.value ?? this.seed,
        pageUnknownOpen: pageUnknownOpen ?? this.pageUnknownOpen,
        lastResult: lastResult?.value ?? this.lastResult,
        tabs: tabs ?? this.tabs,
        activeTab: activeTab ?? this.activeTab,
        activeTabs: activeTabs ?? this.activeTabs,
        tabStacks: tabStacks ?? this.tabStacks,
        isJumpToTopOnRootPage: isJumpToTopOnRootPage ?? this.isJumpToTopOnRootPage,
        isAuthed: isAuthed ?? this.isAuthed,
      );

  @override
  List<Object?> get props => <Object?>[...super.props, isAuthed];

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{...super.mappedFields, 'isAuthed': isAuthed};
}
