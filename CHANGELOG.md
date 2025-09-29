## 0.3.1+1 (29-09-2025)

### Updated

Remove flutter from the dependencies of `mad_navigation` and `mad_navigation_impl`.

## 0.3.1 (24-09-2025)

### Updated

* `NavigationBuilder` now uses the generic type `S extends MadNavigationState` for the parameters
  `upon` and `builder`.

## 0.3.0 (11-09-2025)

### Breaking changes

* `RouterTabDelegate` has been renamed to `TabRouterDelegate`.
* `NavTabPage` has been renamed to `NavTabHolder`.
* `TabPageMapper` has been renamed to `TabHolderMapper`.

## 0.2.0+1 (08-09-2025)

### Added

Full documentation coverage for the entire project.

## 0.2.0 (29-08-2025)

### Breaking changes

For the `MadRouteMapper` class, the principle of registering `NavRoute` object handlers has been
changed. Instead of
directly adding handlers to switch-case, a new API is now used:

* `MadNavMapper` is a base class for grouping routes by type (`PageMapper`, `TabPageMapper`,
  `DialogMapper`, `BottomSheetMapper`), providing typed processing of
  `NavRoute` routes.
* `MadRouteBuilder` — a class for creating route handlers, allowing you to define the route type
  and the associated widget via the `builder` function. Supports route compatibility checking
  via the canHandle method and handler invocation via the `call` method.

### Added

Exception classes inherited from `MadNavigationException`:

* `MissingPageFactoryException` — a `Page` object could not be created for the passed route.
* `UnhandledRouteException` — the route was not handled by any registered handler.
* `DuplicateRouteException` — the route builder has already been added.

### Updated

* The navigation example in `example` has been reworked.

## 0.1.3 (11-08-2025)

### Added

* The `router` directory in the `mad_navigation_flutter` module, including:
  * `MadRouteMapper` — an abstraction for displaying `NavRoute` in `Page` with support for various
    page types (`NavPage`, `NavDialog`, `NavBottomSheet`, etc.);
  * `MadPageFactoryBuilder` — a factory for creating pages with the ability to extend and
    customize them via `buildCustomPageFromMissingNavPage` and
    `buildCustomPageFromMissingNavRoute`;
  * `pages` — contains basic implementations of page types for navigation, including standard
    Flutter pages (`MaterialPage`, `CupertinoPage`) and custom pages with animations (
    `FadeAnimationPage`, `SimplePage`), as well as pages for displaying modal components —
    dialogs (`Dialog`) and bottom sheets (`BottomSheet`);
  * `AppRouterDelegate` — implementation of `RouterDelegate` for managing navigation using
    the root page stack (`MadNavigationService`).
  * `RouterTabDelegate` — implementation of `RouterDelegate` for managing navigation using
    a combined tab stack (`MadTabNavigationService`).
  * `MadUrlParser` — abstraction for parsing and restoring route state (with support for
    flutter web).

## 0.1.2 (21-07-2025)

### Breaking Changes

* Removed PageTabNav from the package.
* Added a new Route class `NavTabPage`. Now, for a basic page with tabs, use
  `NavTabPage` instead of `NavPage`.

### Added

* Added `enableDrag` and `isDismissible` parameters to `NavBottomSheet`.
* Added `isDismissible` parameter to `NavDialog`.

## 0.1.1 (01-07-2025)

### Added

* `DelayedPopTransitionDelegate` — a delegate that allows you to avoid a type error that occurs when
  `pop` is executed quickly.

## 0.1.0 (23-05-2025)

### Breaking Changes

* `MadNavigationState` has been split into two separate classes:
* `MadNavigationState` - the base navigation state class;
* `MadTabNavigationState` - an extended navigation state class for working with tabs.
* `MadNavigationService` has been split into two separate services:
  * `MadNavigationService` - basic navigation service;
  * `MadTabNavigationService` - extended navigation service for working with tabs.
* A similar split has been made for `MadNavigationServiceImpl` into `MadNavigationServiceImpl` and
  `MadTabNavigationServiceImpl`.

### Updated

* Fixed empty stack errors when working with `pop` and `popUntill`;
* Added a type restriction for `NavigationListener` and `NavigationBuilder`;
* Redesigned the navigation example in `example`.

## 0.0.2 (13-05-2025)

### Added

Standard navigation methods:

* `void replaceInRoot<T>({NavRoute<T> oldRoute, NavRoute<T> newRoute})`
* `void replaceInTab<T>({NavRoute<T> oldRoute, NavRoute<T> newRoute})`
* `Future<T?> popAndPushToRoot<T>(NavRoute<T> route, {Object? result})`
* `Future<T?> popAndPushToCurrentTab<T>(NavRoute<T> route, {Object? result})`
* `void popUntil(NavRoutePredicate predicate)`
* `Future<T?> pushAndRemoveUntilForRootStack<T>(NavRoute<T> route, {NavRoutePredicate predicate})`
* `Future<T?> pushAndRemoveUntilForTabStack<T>(NavRoute<T> route, {NavRoutePredicate predicate})`

### Updated

The `PageType` enumeration has been replaced with an `abstract class` to allow for type extension.

## 0.0.1 (05-05-2025)

Initial release

### Added

* The `mad_navigation` module, containing models and descriptions of system navigation methods (not
  including user transitions);
  * The navigation state is described by the `MadNavigationState` class, and the basic methods are
    defined in `MadNavigationService`;
  * `NavPage`, `NavDialog`, and `NavBottomSheet` are used for page, dialog, and BS instances,
    respectively.
  * The `PageTabNav`, `MadTabType`, and `MadTabState` classes have been created to manage tabs.
* The `mad_navigation_impl` module contains the implementation of the `MadNavigationServiceImpl`
  navigator based on the flutter independent package `bloc`.
* The `mad_navigation_flutter` module contains components for managing the application UI, such as
  `NavigationListener` and `NavigationBuilder`.
* Other utilities and extensions of navigation functionality.
