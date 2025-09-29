part of 'route_mapper.dart';

class _SlideFromLeftPage<T> extends Page<T> {
  const _SlideFromLeftPage({
    required LocalKey? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  static final Animatable<Offset> _slideTween = Tween<Offset>(
    begin: const Offset(1, 0),
    end: Offset.zero,
  ).chain(
    CurveTween(curve: Curves.easeOutCubic),
  );

  static const Duration _duration = Duration(milliseconds: 500);

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      transitionDuration: _duration,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return child;
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return SlideTransition(
          position: animation.drive(_slideTween),
          child: child,
        );
      },
    );
  }
}
