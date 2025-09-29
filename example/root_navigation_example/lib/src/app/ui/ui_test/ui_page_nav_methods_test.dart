import 'package:root_navigation_example/main.dart';
import 'package:root_navigation_example/src/app/app.dart';

class UiPageNavMethodsTest extends StatefulWidget {
  const UiPageNavMethodsTest({super.key, required this.id});

  final int id;

  @override
  State<UiPageNavMethodsTest> createState() => _UiPageNavMethodsTestState();
}

class _UiPageNavMethodsTestState extends State<UiPageNavMethodsTest> {
  final ValueNotifier<Object?> _pageResultNotifier = ValueNotifier<Object?>(null);
  final ValueNotifier<PageType> _pageTypeNotifier = ValueNotifier<PageType>(const MaterialPageType());

  final List<PageType> _pageTypes = const <PageType>[
    MaterialPageType(),
    CupertinoPageType(),
    FadePageType(),
    SimplePageType(),
    SlideFromTopPageType(),
  ];

  int get id => widget.id;

  PageType get _pageType => _pageTypeNotifier.value;

  @override
  void dispose() {
    _pageResultNotifier.dispose();
    _pageTypeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEvenId = id % 2 == 0;

    final Color primaryColor = Theme.of(context).primaryColor;
    final Widget divider = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(color: primaryColor),
    );

    return AppScaffold(
      title: Text('Nav methods test with id ${id}'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Select page transition type:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: ValueListenableBuilder<PageType>(
                  valueListenable: _pageTypeNotifier,
                  builder: (BuildContext context, PageType pageType, _) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButton<PageType>(
                          value: pageType,
                          underline: const SizedBox(),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: primaryColor,
                          ),
                          items: <DropdownMenuItem<PageType>>[
                            for (final PageType pageType in _pageTypes)
                              DropdownMenuItem<PageType>(
                                value: pageType,
                                child: Text(pageType.runtimeType.toString()),
                              ),
                          ],
                          onChanged: (PageType? newPageType) {
                            if (newPageType != null) {
                              _pageTypeNotifier.value = newPageType;
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            divider,
            ValueListenableBuilder<Object?>(
              valueListenable: _pageResultNotifier,
              builder: (BuildContext context, Object? value, _) {
                return Text(
                  'Current result:\n$value',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ElevatedButton(
                onPressed: () async {
                  final Object? result = await navigationService.pushToRoot(PageObjectResultTest(_pageType));
                  _pageResultNotifier.value = result;
                },
                child: const Text(
                  'Open new page with result',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            divider,
            ElevatedButton(
              onPressed: () {
                navigationService.pushToRoot(PageCounterTest(const PageCounterTestArgs(), _pageType));
              },
              child: const Text('Open counter test page'),
            ),
            ElevatedButton(
              onPressed: () {
                navigationService.pushToRoot(PageItemListTest(_pageType));
              },
              child: const Text('Open item list test page'),
            ),
            ElevatedButton(
              onPressed: () {
                navigationService.pushToRoot(PageProfileTest(_pageType));
              },
              child: const Text('Open profile page'),
            ),
            ElevatedButton(
              onPressed: () {
                navigationService.pushToRoot(DialogUnknown());
              },
              child: const Text(
                'Open unknown dialog',
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                navigationService.pushToRoot(BottomSheetUnknown());
              },
              child: const Text(
                'Open unknown bottom sheet',
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (isEvenId) {
                  final int? result = await navigationService.pushToRoot(PageNavMethodsTest<int>(id + 1, _pageType));
                  debugPrint('Int result: $result');
                } else {
                  final String? result =
                      await navigationService.pushToRoot(PageNavMethodsTest<String>(id + 1, _pageType));
                  debugPrint('String result: $result');
                }
              },
              child: const Text('Push'),
            ),
            ElevatedButton(
              onPressed: () {
                navigationService.replaceInRoot(
                  oldRoute: navigationService.state.rootStack.last,
                  newRoute: PageNavMethodsTest<void>(id + 1, _pageType),
                );
              },
              child: const Text('Replace'),
            ),
            ElevatedButton(
              onPressed: () {
                navigationService.pop(result: isEvenId ? id.toString() : id);
              },
              child: const Text('Pop'),
            ),
            ElevatedButton(
              onPressed: () {
                navigationService.popAndPushToRoot(PageNavMethodsTest<void>(id + 1, _pageType));
              },
              child: const Text('Pop & push'),
            ),
            ElevatedButton(
              onPressed: () {
                navigationService.popUntil(
                  (AnyNavRoute predicate) => predicate.urlString.contains(
                    PageNavMethodsTest.buildRouteName(id - 2),
                  ),
                );
              },
              child: Text('Pop until PageNavMethodTest(${id - 2})'),
            ),
            ElevatedButton(
              onPressed: () {
                navigationService.pushAndRemoveUntilForRootStack(
                  PageNavMethodsTest<void>(id + 1, _pageType),
                  predicate: (AnyNavRoute predicate) => predicate.urlString.contains(
                    PageNavMethodsTest.buildRouteName(id - 2),
                  ),
                );
              },
              child: Text(
                'Push & remove until PageNavMethodTest(${id - 2})',
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                navigationService.resetRootStack(<AnyNavRoute>{PageNavMethodsTest<void>(0, _pageType)});
              },
              child: const Text('Reset stack'),
            ),
          ],
        ),
      ),
    );
  }
}
