import 'package:mad_navigation/src/src.dart';

part 'nav_routes.dart';

/// A type alias for a navigation route with dynamic type parameter.
typedef AnyNavRoute = NavRoute<dynamic>;

/// A type alias for a set of navigation routes that represents the current navigation stack.
typedef RouteStack = Set<AnyNavRoute>;

/// Base class for defining tab types in the application navigation.
///
/// Implement this class to define different types of tabs in your application.
/// Each tab type should have a unique [name] identifier.
abstract class MadTabType {
  const MadTabType();

  /// The unique identifier for this tab type.
  abstract final String name;
}

/// Base class for defining different types of pages in the application.
///
/// Extend this class to create specific page types that can be used with
/// the navigation system.
abstract class PageType {
  const PageType();
}

/// Represents a Material Design style page.
///
/// Use this page type for pages that should follow Material Design guidelines.
final class MaterialPageType extends PageType {
  const MaterialPageType();
}

/// Represents a Cupertino (iOS) style page.
///
/// Use this page type for pages that should follow iOS design guidelines.
final class CupertinoPageType extends PageType {
  const CupertinoPageType();
}

/// Represents a page with a fade transition effect.
///
/// This page type applies a fade animation when navigating between pages.
final class FadePageType extends PageType {
  const FadePageType();
}

/// Represents a simple page without any special transitions.
///
/// This is the most basic page type with default navigation behavior.
final class SimplePageType extends PageType {
  const SimplePageType();
}

/// Base class for all navigation routes in the application.
///
/// [T] - the type of result that will be returned when this route is popped.
abstract class NavRoute<T> extends Equatable with Stringify {
  /// Creates a new navigation route with the given path.
  NavRoute(this._path);

  final String _path;

  /// The URL string that identifies this route.
  String get urlString => _path;

  /// A unique key that identifies this route's page.
  ///
  /// By default, this returns the [urlString], but can be overridden
  /// to provide a different key if needed.
  Object get pageKey => urlString;

  final Completer<T?> _popCompleter = Completer<T?>();

  /// A future that completes when this route is popped from the navigation stack.
  ///
  /// The future will complete with the result value passed when the route was popped,
  /// or null if no result was provided.
  Future<T?> get popped => _popCompleter.future;

  /// Completes the [_popCompleter] with the given result.
  ///
  /// This is typically called when the route is being removed from the navigation stack.
  void complete(T? result) => _popCompleter.complete(result);

  /// Creates a predicate that checks if a route matches the given route.
  static NavRoutePredicate isRoutePredicate(AnyNavRoute route) {
    return (AnyNavRoute entry) => entry == route;
  }

  @override
  List<Object?> get props => <Object?>[_path, pageKey];

  @override
  Map<String, dynamic> get mappedFields => <String, dynamic>{
        '_path': _path,
        if (pageKey != _path) 'pageKey': pageKey,
        '_popCompleter': _popCompleter,
      };
}

/// Base class for page-based navigation routes.
///
/// [T] - the type of result that will be returned when this page is popped.
abstract class NavPage<T> extends NavRoute<T> {
  /// Creates a new page route with the given path and page type.
  NavPage(
    String path, {
    this.type = const FadePageType(),
  }) : super('page-$path');

  /// The type of page transition to use when navigating to this page.
  final PageType type;
}

/// Base class for tab-based navigation holders.
///
/// [T] - the type of result that will be returned when this tab page is popped.
abstract class NavTabHolder<T> extends NavRoute<T> {
  /// Creates a new tab holder route with the given path.
  NavTabHolder(String path) : super('tab-holder-$path');
}

/// Base class for dialog-based navigation routes.
///
/// [T] - the type of result that will be returned when this dialog is dismissed.
abstract class NavDialog<T> extends NavRoute<T> {
  /// Creates a new dialog route with the given path and the option to close it.
  NavDialog(String path, {this.isDismissible = true}) : super('dialog-$path');

  /// Whether the dialog can be dismissed by tapping outside of it.
  final bool isDismissible;
}

/// Base class for bottom sheet navigation routes.
///
/// [T] - the type of result that will be returned when this bottom sheet is dismissed.
abstract class NavBottomSheet<T> extends NavRoute<T> {
  /// Creates a new bottom sheet route with the given path and configuration.
  NavBottomSheet(
    String path, {
    this.isDismissible = true,
    this.enableDrag = true,
  }) : super('bottom-sheet-$path');

  /// Whether the bottom sheet can be dismissed by tapping outside of it.
  final bool isDismissible;

  /// Whether the bottom sheet can be dragged up and down.
  final bool enableDrag;
}
