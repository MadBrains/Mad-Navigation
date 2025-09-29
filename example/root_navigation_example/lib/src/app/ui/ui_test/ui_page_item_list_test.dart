import 'package:root_navigation_example/main.dart';
import 'package:root_navigation_example/src/app/app.dart';

class UiPageItemListTest extends StatelessWidget {
  const UiPageItemListTest({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: const Text('Item list test'),
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (BuildContext context, int index) => ListTile(
          title: Text('Item $index'),
          onTap: () {
            navigationService.openPageObjectResultTest();
          },
        ),
      ),
    );
  }
}
