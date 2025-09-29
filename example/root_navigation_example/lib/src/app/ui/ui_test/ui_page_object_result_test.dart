import 'package:root_navigation_example/main.dart';
import 'package:root_navigation_example/src/app/app.dart';

class UiPageObjectResultTest extends StatelessWidget {
  const UiPageObjectResultTest({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: const Text('Object result test'),
      body: CenteredButton(
        onPressed: () => navigationService.pop(result: DateTime.now().toString()),
        child: const Text('Return current date'),
      ),
    );
  }
}
