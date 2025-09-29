part of 'route_mapper.dart';

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
}
