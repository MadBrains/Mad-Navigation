import 'package:tab_navigation_example/main.dart';
import 'package:tab_navigation_example/src/app/app.dart';

class UiPageScrollToTopTest extends StatelessWidget {
  const UiPageScrollToTopTest({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollToTopListener(
      navigationService: navigationService,
      tab: navigationService.state.activeTab,
      builder: (BuildContext context, ScrollController controller) {
        return AppScaffold(
          title: const Text('ScrollToTop test'),
          actions: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Tooltip(
                message: 'Press tab again to execute scrollToTop',
                child: Icon(Icons.info),
              ),
            ),
          ],
          body: ListView.builder(
            controller: controller,
            itemCount: 100,
            itemBuilder: (BuildContext context, int index) => ListTile(
              title: Text('Item $index'),
              onTap: () {
                navigationService.openPageObjectResultTest();
              },
            ),
          ),
        );
      },
    );
  }
}
