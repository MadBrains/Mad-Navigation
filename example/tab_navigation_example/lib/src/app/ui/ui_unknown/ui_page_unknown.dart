import 'package:tab_navigation_example/src/app/app.dart';

class UiPageUnknown extends StatelessWidget {
  const UiPageUnknown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Page not found')));
  }
}
