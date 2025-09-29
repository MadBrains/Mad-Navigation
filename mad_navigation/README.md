# Mad Navigation

A BLoC-driven navigation library for Flutter, designed for type-safe, scalable, and maintainable navigation. It supports both root and tab-based navigation stacks, making it suitable for complex app architectures.

## Features

- 🚀 BLoC-based navigation architecture for predictable state management
- 🧭 Supports both root-level and tab-based navigation stacks
- 🛣️ Type-safe route and tab definitions for compile-time safety
- 🔄 State preservation and restoration across navigation events
- 🎨 Customizable page transitions and navigation animations
- 🧩 Extensible route mapping for pages, dialogs, and bottom sheets
- 🔔 Navigation listeners and builders for UI reactions to navigation changes
- 🌐 URL parsing and restoration for deep linking and browser navigation (soon)
- 🧑‍💻 Example implementations for root and tab navigation patterns

## Installation

Add the following dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  mad_navigation: [latest-version]  # Pure Dart: navigation interfaces and abstractions, independent of Flutter
  mad_navigation_impl: [latest-version]  #  Pure Dart: implementation of navigation logic, can be used independently or customized
  mad_navigation_flutter: [latest-version]  # Integration with Flutter: connects navigation with widgets and routers
```

Then run:

```bash
flutter pub get
```

## Getting started

### Basic navigation setup

1) Define your routes:

```dart
import 'package:mad_navigation/mad_navigation.dart';

class PageCounter extends NavPage<dynamic> {
  const PageCounter() : super('counter');
}

class PageProfile extends NavPage<dynamic> {
  const PageProfile(this.model) : super('profile');

  final ProfileModel model;
}
```

2) Set up your navigation service:

```dart
import 'package:mad_navigation_impl/mad_navigation_impl.dart';

final class NavigationState extends MadNavigationState { ... }

final class NavigationServiceImpl extends MadNavigationServiceImpl<NavigationState> {
  NavigationServiceImpl() : super(NavigationState());

  // Resets navigation state by dispatching a new state event.
  void reset() {
    add(NavigationUpdateStateEvent(NavigationState()));
  }

  // Opens the Counter page.
  void openPageCounter() => pushToRoot(PageCounter());

  // Opens the Profile page and returns a result of type [ProfileModel].
  Future<ProfileModel?> openPageProfile(ProfileModel model) => pushToRoot<ProfileModel>(PageProfile(model));
}
```

> The declarative approach to navigation state management allows you to update the entire navigation stack at once using the `NavigationUpdateStateEvent` event. This pattern is ideal for scenarios like state restoration after app restart, implementing deep linking, or creating complex navigation flows. By working with the complete navigation state, you maintain full control while keeping your navigation logic clean and maintainable.

> Open functions like `openPageCounter` and `openPageProfile` encapsulate navigation logic, making calls type-safe, readable, and easy to maintain. This approach centralizes navigation, simplifies argument/result handling, and helps refactor navigation flows in one place.

3) Set up your route mapper:

```dart
import 'package:mad_navigation_flutter/mad_navigation_flutter.dart';

class RouteMapper extends MadRouteMapper {
  @override
  List<MadNavMapper<AnyNavRoute>> get routers => <MadNavMapper<AnyNavRoute>>[
    PageMapper(
      routes: <MadRouteBuilder<NavPage<dynamic>>>[
        MadRouteBuilder<PageCounter>((_) => const UiPageCounter()),
        MadRouteBuilder<PageProfile>((PageProfile page) => UiPageProfile(page.model)),
      ],
    ),
  ];
}
```

4) Set up your app with the navigation service:

```dart
import 'package:mad_navigation_impl/mad_navigation_impl.dart';

void main() {
  // It's recommended to use your DI container to provide navigationService.
  final navigationService = NavigationServiceImpl();

  runApp(App(navigationService: navigationService));
}

class App extends StatelessWidget {
  const App({super.key, required this.navigationService});

  final NavigationService navigationService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: AppRouterDelegate(
        navigatorKey: GlobalKey(),
        navigationService: navigationService,
        routeMapper: RouteMapper(),
      ),
      routeInformationParser: UrlParser(navigationService),
    );
  }
}
```

### Tab-based navigation setup

If your app uses tabs, you should use `MadTabNavigationService` instead of the default navigation service.  

1) Add to your routes:

```dart
class MainTabHolder extends NavTabHolder<dynamic> {
  const MainTabHolder() : super('main');
}

class PageSetting extends NavPage<dynamic> {
  const PageTest() : super('settings');
}

class PageChat extends NavPage<dynamic> {
  const PageChat() : super('chat');
}
```

2) Set up your tab types:

```dart
import 'package:mad_navigation/mad_navigation.dart';

final class CounterTabType extends MadTabType {
  const CounterTabType();

  @override
  String get name => 'Counter';
}

final class ProfileTabType extends MadTabType {
  const ProfileTabType();

  @override
  String get name => 'Profile';
}
```

2) Set up your navigation service:

```dart
final class TabNavigationState extends MadTabNavigationState { ... }

final class TabNavigationServiceImpl extends MadTabNavigationServiceImpl<TabNavigationState> {
  TabNavigationServiceImpl() : super(TabNavigationState());

  // methods
}
```

3) Add to your route mapper:

```dart
TabHolderMapper(
  routes: <MadRouteBuilder<NavTabHolder<dynamic>>>[
    MadRouteBuilder<MainTabHolder>((_) => const UiMainTabHolder()),
  ],
)
```

4) Set up your tab bar:

```dart
import 'package:mad_navigation_flutter/mad_navigation_flutter.dart';

class AppTabBar extends StatefulWidget {
  const AppTabBar({super.key, required this.navigationService});

  final TabNavigationService navigationService;

  @override
  State<AppTabBar> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar> with SingleTickerProviderStateMixin {
  late final TabController _controller;

  TabNavigationService get _navigationService => widget.navigationService;
  
  @override
  void initState() {
    super.initState();
    _controller = TabController(
      initialIndex: _navigationService.state.activeTabIndex,
      length: _navigationService.state.tabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onIndexChanged(TabNavigationState state) {
    _controller.index = state.activeTabIndex;
  }

  void _selectTab(BuildContext context, MadTabType tab) {
    _navigationService.selectTabByUser(tab);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationListener<TabNavigationState>(
      navigationService: _navigationService,
      listener: (BuildContext context, TabNavigationState state, TabNavigationState prevState) => _onIndexChanged(state),
      upon: (TabNavigationState state) => <Object>[state.activeTab],
      child: TabBar(
        onTap: (int index) => _selectTab(context, state.tabs[index]),
        controller: _controller,
        tabs: <Widget>[
          for (final MadTabType type in state.tabs) AppTabBarItem(...),
        ],
      ),
    );
  }
}
```

5) Set up your tab page with the navigation service:

```dart
import 'package:mad_navigation_flutter/mad_navigation_flutter.dart';

class UiMainTabHolder extends StatelessWidget {
  const UiMainTabHolder({super.key, required this.navigationService});

  final NavigationService navigationService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Router<dynamic>(
        routerDelegate: TabRouterDelegate<TabNavigationState>(
          navigatorKey: navigatorKey,
          navigationService: navigationService,
          routeMapper: RouteMapper(),
        ),
      ),
      bottomNavigationBar: AppTabBar(navigationService: navigationService),
    );
  }
}
```

## Navigation Patterns

Mad Navigation provides a comprehensive set of navigation methods for both root and tab-based navigation stacks. You can access the navigation service via dependency injection, provider, or directly.

## Navigation Patterns

Below are all available navigation methods from `MadNavigationService` and `MadTabNavigationService`, formatted for clarity:

### Root Stack Navigation (`MadNavigationService`)

**Push a new page to the root stack**
```dart
navigationService.pushToRoot(const PageCounter());
```

**Refresh the current navigation state**
```dart
navigationService.refresh();
```

**Replace an existing route in the root stack**
```dart
navigationService.replaceInRoot(
  oldRoute: const PageCounter(),
  newRoute: PageProfile(model),
);
```

**Pop the current route from the stack**
```dart
navigationService.pop(result: result);
```

**Pop the current route and push a new one**
```dart
navigationService.popAndPushToRoot<Object>(const PageProfile(model), result: result);
```

**Pop routes until a predicate returns true**
```dart
navigationService.popUntil((route) => route is PageCounter);
```

**Push a route and remove all previous routes until predicate returns true**
```dart
navigationService.pushAndRemoveUntilForRootStack(
  const PageProfile(model),
  predicate: (route) => route is PageCounter,
);
```

**Reset the root navigation stack**
```dart
navigationService.resetRootStack(newRouteStack);
```

---

### Tab Stack Navigation (`MadTabNavigationService`)

**Select a tab by user interaction**
```dart
tabNavigationService.selectTabByUser(const CounterTabType());
```

**Change the current tab programmatically**
```dart
tabNavigationService.changeTab(const ProfileTabType());
```

**Push a new page to the current tab stack**
```dart
tabNavigationService.pushToCurrentTab(const PageSettings());
```

**Replace an existing route in the current tab stack**
```dart
tabNavigationService.replaceInTab(
  oldRoute: const PageSettings(),
  newRoute: const PageChat(),
);
```

**Pop the current route and push a new one in the current tab**
```dart
tabNavigationService.popAndPushToCurrentTab(const PageChat(), result: result);
```

**Push a route and remove previous routes in the current tab until predicate returns true**
```dart
tabNavigationService.pushAndRemoveUntilForTabStack(
  const PageProfile(model),
  predicate: (route) => route is PageSettings,
);
```

**Reset the navigation stack for a specific tab**
```dart
tabNavigationService.resetTabStack(newRouteStack, tab: const CounterTabType());
```

**Reset the "jump to top" flag for the current root page**
```dart
tabNavigationService.resetJumpToTopOnRootPage();
```

See the example projects for more advanced patterns and custom navigation flows.

## Passing Arguments

Mad Navigation allows you to pass strongly-typed arguments to your routes. Simply define your route classes with the required fields, and provide them when navigating.

For example, a page route with arguments:

```dart
class PageProfile extends NavPage<Never> {
  const PageProfile(this.model) : super('profile');

  final ProfileModel model;
}
```

To navigate and pass arguments:

```dart
navigationService.pushToRoot(PageProfile(profileModel));
```

Arguments are always passed as constructor parameters, ensuring type safety and compile-time checks.

> We strongly recommend passing only data classes and primitives as route arguments.
Avoid passing logic objects (such as BLoC, controllers, or Flutter widgets) through navigation.
For logic and dependencies, use dependency injection (DI) or context mechanisms instead.
This keeps navigation type-safe, predictable, and decoupled from business logic.

## Returning Results

You can return results from pages using the navigation service. The result type is inferred from your route's generic type. You can expect results from a pushed page.

```dart
final bool? result = await navigationService.pushToRoot<bool>(PageLogin());
```

Then, inside your page, pop with a result:

```dart
navigationService.pop(result: true);
```

## Custom Page Types

Mad Navigation provides several built-in page types for transitions, such as `MaterialPageType`, `CupertinoPageType`, `FadePageType`, and `SimplePageType`.  
If you need a custom transition or page behavior, you can easily create your own page type by following these steps:

1) Define your custom PageType

```dart
final class SlideFromLeftPageType extends PageType {
  const SlideFromLeftPageType();
}
```

2) Implement your custom Page

```dart
class _SlideFromLeftPage<T> extends Page<T> {
  const _SlideFromLeftPage({
    required LocalKey? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  static const Duration _duration = Duration(milliseconds: 500);

  static final Animatable<Offset> _slideTween = Tween<Offset>(
    begin: const Offset(1, 0),
    end: Offset.zero,
  ).chain(
    CurveTween(curve: Curves.easeOutCubic),
  );

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      transitionDuration: _duration,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(_slideTween),
          child: child,
        );
      },
    );
  }
}
```

3) Extend `MadPageFactoryBuilder` to support your custom type

Override the `buildCustomPageFromMissingNavPage` method to handle your custom page type and `buildCustomPageFromMissingNavRoute` to handle your custom route type:

```dart
class PageFactoryBuilder extends MadPageFactoryBuilder {
  const PageFactoryBuilder();

  @override
  Page<T>? buildCustomPageFromMissingNavPage<T>(
    LocalKey? key,
    NavPage<dynamic> navRoute,
    Widget child,
  ) {
    return switch (navRoute.type) {
      SlideFromLeftPageType() => _SlideFromLeftPage<T>(key: key, child: child),
      (_) => null,
    };
  }

  @override
  Page<T>? buildCustomPageFromMissingNavRoute<T>(LocalKey? key, AnyNavRoute navRoute, Widget child) { ... }
}
```

### 4. Use your custom factory in the route mapper

Pass your custom `PageFactoryBuilder` to the super constructor:

```dart
class RouteMapper extends MadRouteMapper {
  RouteMapper() : super(pageBuilder: const PageFactoryBuilder());
}
```

Now you can use your custom page type in your routes:

```dart
class SlidePage extends NavPage {
  const SlidePage() : super('slide', type: const SlideFromLeftPageType());
}
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

You can support mad_navigation by giving it a like on Pub, starring it on GitHub, suggesting improvements for specific features, or reporting any issues you come across.
