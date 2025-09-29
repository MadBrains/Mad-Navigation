import 'package:root_navigation_example/main.dart';
import 'package:root_navigation_example/src/app/app.dart';

class UiPageProfileTest extends StatelessWidget {
  const UiPageProfileTest({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: const Text('Profile test'),
      body: CenteredButton(
        onPressed: () => navigationService.logout(),
        child: const Text('Logout', style: TextStyle(color: Colors.red)),
      ),
    );
  }
}
