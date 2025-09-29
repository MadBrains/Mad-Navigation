part of 'route_mapper.dart';

/// A Material Design style page implementation.
///
/// Wraps [MaterialPage] with a consistent constructor signature, where `T` is the type
/// of result returned when the page is popped.
class _MaterialPage<T> extends MaterialPage<T> {
  /// Creates a Material page with the given [child] widget.
  ///
  /// The [key] is used to identify the page in the navigation stack.
  const _MaterialPage({required LocalKey? key, required Widget child}) : super(key: key, child: child);
}

/// A Cupertino style page implementation.
///
/// Wraps [CupertinoPage] with a consistent constructor signature, where `T` is the type
/// of result returned when the page is popped.
class _CupertinoPage<T> extends CupertinoPage<T> {
  /// Creates a Cupertino page with the given [child] widget.
  ///
  /// The [key] is used to identify the page in the navigation stack.
  const _CupertinoPage({required LocalKey? key, required Widget child}) : super(key: key, child: child);
}

/// A page with a fade-in animation when it's pushed onto the navigation stack.
///
/// Uses a [FadeTransition] with an ease-in curve for smooth transitions between routes,
/// where `T` is the type of result returned when the page is popped.
class _FadeAnimationPage<T> extends Page<T> {
  /// Creates a page with a fade animation.
  ///
  /// The [key] is used to identify the page in the navigation stack.
  /// The [child] is the widget to display in the page.
  const _FadeAnimationPage({required LocalKey? key, required this.child}) : super(key: key);

  /// The widget to display in the page.
  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        final CurveTween curveTween = CurveTween(curve: Curves.easeIn);

        return FadeTransition(opacity: animation.drive(curveTween), child: child);
      },
    );
  }
}

/// A basic page with no transition animations.
///
/// Displays its child widget without animations, where `T` is the type of result
/// returned when the page is popped.
class _SimplePage<T> extends Page<T> {
  /// Creates a simple page with the given [child] widget.
  ///
  /// The [key] is used to identify the page in the navigation stack.
  const _SimplePage({required LocalKey? key, required this.child}) : super(key: key);

  /// The widget to display in the page.
  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return child;
      },
    );
  }
}

/// A dialog page that can be pushed onto the navigation stack.
///
/// Creates a modal dialog with proper theming, where `T` is the type of result
/// returned when the dialog is dismissed.
class _Dialog<T> extends Page<T> {
  /// Creates a dialog page with the given [child] widget.
  ///
  /// The [key] is used to identify the page in the navigation stack.
  const _Dialog({required LocalKey? key, required this.child}) : super(key: key);

  /// The widget to display in the dialog.
  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(context).context,
    );

    return DialogRoute<T>(
      themes: themes,
      context: context,
      settings: this,
      builder: (BuildContext context) => child,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    );
  }
}

/// A bottom sheet page that slides up from the bottom of the screen.
///
/// Creates a modal bottom sheet with proper theming, where `T` is the type of result
/// returned when the bottom sheet is dismissed.
class _BottomSheet<T> extends Page<T> {
  /// Creates a bottom sheet page with the given [child] widget.
  ///
  /// The [key] is used to identify the page in the navigation stack.
  const _BottomSheet({required LocalKey? key, required this.child}) : super(key: key);

  /// The widget to display in the bottom sheet.
  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(context).context,
    );

    return ModalBottomSheetRoute<T>(
      capturedThemes: themes,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      isScrollControlled: false,
      settings: this,
      builder: (BuildContext context) => child,
    );
  }
}
