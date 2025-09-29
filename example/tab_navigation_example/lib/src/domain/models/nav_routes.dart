part of 'navigation_state.dart';

class PageLoginTest extends NavPage<Never> {
  PageLoginTest() : super('login');
}

class PageProfileTest extends NavPage<Never> {
  PageProfileTest() : super('profile');
}

class PageCounterTest extends NavPage<Never> {
  PageCounterTest(this.args) : super('counter-test-${args.id}');

  final PageCounterTestArgs args;
}

class PageNavMethodsTest<T> extends NavPage<T> {
  PageNavMethodsTest(this.id, [PageType type = const FadePageType()])
      : super(
          buildRouteName(id),
          type: type,
        );

  static String buildRouteName(int id) => 'nav-method-test-$id';

  final int id;
}

class PageScrollToTopTest extends NavPage<Never> {
  PageScrollToTopTest() : super('scroll-to-top-test');
}

class PageObjectResultTest extends NavPage<Object> {
  PageObjectResultTest([PageType type = const FadePageType()])
      : super(
          'object-result-test',
          type: type,
        );
}

class MainTabHolder extends NavTabHolder<Never> {
  MainTabHolder() : super('main');
}

class DialogTest extends NavDialog<String> {
  DialogTest() : super('test');
}

class BottomSheetTest extends NavBottomSheet<Never> {
  BottomSheetTest() : super('test');
}
