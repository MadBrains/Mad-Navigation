import 'package:root_navigation_example/main.dart';
import 'package:root_navigation_example/src/app/app.dart';

class UiPageLoginTest extends StatelessWidget {
  const UiPageLoginTest({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: const Text('Login test'),
      body: CenteredButton(
        onPressed: () => navigationService.login(),
        child: const Text('Login'),
      ),
    );
  }
}
