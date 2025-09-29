import 'package:tab_navigation_example/main.dart';
import 'package:tab_navigation_example/src/app/app.dart';

class UiDialogUnknown extends StatelessWidget {
  const UiDialogUnknown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text('Dialog not found'),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () => navigationService.pop(),
        ),
      ],
    );
  }
}
