import 'package:mad_navigation/src/src.dart';

/// Represents the state of the application's navigation.
///
/// This class holds information about the current navigation stack, active routes,
/// and other navigation-related state.
class MadNavigationState extends Equatable with Stringify {
  /// Creates a new navigation state.
  MadNavigationState({
    required this.rootStack,
    required this.seed,
    required this.pageUnknownOpen,
    required this.lastResult,
  });

  /// The root navigation stack.
  final RouteStack rootStack;

  /// An optional seed value used for state restoration or identification.
  final String? seed;

  /// Whether the unknown page is currently open.
  final bool pageUnknownOpen;

  /// The result from the last navigation operation.
  final Object? lastResult;

  /// The complete route stack, including the unknown page if it's open.
  late final RouteStack routeStack = formRouteStack();

  /// The currently active navigation stack.
  late final RouteStack activeStack = routeStack;

  /// The currently active route.
  late final AnyNavRoute activeRoute = activeStack.last;

  /// Whether the current navigation stack can be popped.
  late final bool canPop = routeStack.length > 1 || activeStack.length > 1;

  /// Forms the complete route stack including the unknown page if needed.
  RouteStack formRouteStack() => <AnyNavRoute>{
        ...rootStack,
        if (pageUnknownOpen) PageUnknown(),
      };

  /// Creates a copy of this state with the given fields replaced.
  MadNavigationState copyWith({
    RouteStack? rootStack,
    Nullable<String?>? seed,
    bool? pageUnknownOpen,
    Nullable<Object?>? lastResult,
  }) =>
      MadNavigationState(
        rootStack: rootStack ?? this.rootStack,
        seed: seed?.value ?? this.seed,
        pageUnknownOpen: pageUnknownOpen ?? this.pageUnknownOpen,
        lastResult: lastResult?.value ?? this.lastResult,
      );

  @override
  List<Object?> get props => <Object?>[
        rootStack,
        seed,
        pageUnknownOpen,
        lastResult,
      ];

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{
        'rootStack': rootStack,
        'seed': seed,
        'pageUnknownOpen': pageUnknownOpen,
        'lastResult': lastResult,
        'routeStack': routeStack,
        'activeStack': activeStack,
        'activeRoute': activeRoute,
        'canPop': canPop,
      };
}

/// Represents the state of a tab-based navigation.
///
/// Extends [MadNavigationState] with tab-specific navigation state.
abstract class MadTabNavigationState extends MadNavigationState {
  /// Creates a new tab navigation state.
  MadTabNavigationState({
    required super.rootStack,
    required super.seed,
    required super.pageUnknownOpen,
    required super.lastResult,
    required this.tabs,
    required this.activeTab,
    required this.activeTabs,
    required this.tabStacks,
    required this.isJumpToTopOnRootPage,
  });

  /// The list of all available tabs.
  final List<MadTabType> tabs;

  /// The currently active tab.
  final MadTabType activeTab;

  /// The set of currently active tabs.
  final Set<MadTabType> activeTabs;

  /// The navigation stacks for each tab.
  final List<Set<AnyNavRoute>> tabStacks;

  /// Whether to jump to the top when the root page is active.
  final bool isJumpToTopOnRootPage;

  /// The merged navigation stack from all tabs.
  late final RouteStack mergedTabStack = _formTabStack();

  /// The navigation stack for the [activeTab].
  late final RouteStack selectedStack = _getTabStack(activeTab);

  /// The index of the currently [activeTab].
  late final int activeTabIndex = tabs.indexOf(activeTab);

  /// Whether the current route is a tab page.
  late final bool tabIsActive = routeStack.last is NavTabHolder;

  @override
  late final RouteStack activeStack = tabIsActive ? selectedStack : routeStack;

  /// Gets the page associated with a specific tab.
  NavPage<dynamic> getPageByTab(MadTabType tab);

  @override
  MadTabNavigationState copyWith({
    RouteStack? rootStack,
    Nullable<String?>? seed,
    bool? pageUnknownOpen,
    Nullable<Object?>? lastResult,
    List<MadTabType>? tabs,
    MadTabType? activeTab,
    Set<MadTabType>? activeTabs,
    List<Set<AnyNavRoute>>? tabStacks,
    bool? isJumpToTopOnRootPage,
  });

  @override
  List<Object?> get props => <Object?>[
        ...super.props,
        tabs,
        activeTab,
        activeTabs,
        tabStacks,
        isJumpToTopOnRootPage,
      ];

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{
        ...super.mappedFields,
        'tabs': tabs,
        'activeTab': activeTab,
        'activeTabs': activeTabs,
        'tabStacks': tabStacks,
        'isJumpToTopOnRootPage': isJumpToTopOnRootPage,
      };
}

extension on MadTabNavigationState {
  RouteStack get _unSelectedRouteStack => tabs.fold(
        <AnyNavRoute>{},
        (RouteStack routeStack, MadTabType tab) {
          if (_check(tab)) {
            routeStack.addAll(_getTabStack(tab));
          }

          return routeStack;
        },
      );

  bool _check(MadTabType type) =>
      activeTab != type && activeTabs.contains(type) && tabs.contains(type);

  RouteStack _getTabStack(MadTabType tab) => tabStacks[tabs.indexOf(tab)];

  RouteStack _formTabStack() => <AnyNavRoute>{
        ..._unSelectedRouteStack,
        ...selectedStack,
      };
}

/// Extension providing utility methods for route stacks.
extension ListNavTypeContext on RouteStack {
  /// Gets the current location path for this route stack.
  ///
  /// If [tabName] is provided, includes it as the root of the path.
  String getLocation([String? tabName]) {
    final String path = fold('', (String previousValue, AnyNavRoute element) {
      if (element is NavDialog || element is NavBottomSheet) {
        return '$previousValue#${element.urlString}';
      }

      return '$previousValue/${element.urlString}';
    });

    return tabName != null ? '/$tabName$path' : path;
  }
}
