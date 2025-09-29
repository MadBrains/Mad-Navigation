part of 'navigation_state.dart';

class PageLoginTest extends NavPage<Never> {
  PageLoginTest() : super('login-test');
}

class PageItemListTest extends NavPage<Never> {
  PageItemListTest([PageType type = const FadePageType()]) : super('item-list', type: type);
}

class PageProfileTest extends NavPage<Never> {
  PageProfileTest([PageType type = const FadePageType()]) : super('profile-test', type: type);
}

class PageCounterTest extends NavPage<Never> {
  PageCounterTest(this.args, [PageType type = const FadePageType()])
      : super(
          'counter-test-${args.id}',
          type: type,
        );

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

class PageObjectResultTest extends NavPage<Object> {
  PageObjectResultTest([PageType type = const FadePageType()])
      : super(
          'object-result-test',
          type: type,
        );
}

class DialogTest extends NavDialog<String> {
  DialogTest() : super('test');
}

class BottomSheetTest extends NavBottomSheet<Never> {
  BottomSheetTest() : super('test');
}
