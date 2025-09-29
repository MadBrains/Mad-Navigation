import 'package:tab_navigation_example/src/app/app.dart';

class UiPageCounterTest extends StatefulWidget {
  const UiPageCounterTest({super.key, required this.id});

  UiPageCounterTest.fromArgs(PageCounterTestArgs args) : this(id: args.id);

  final int id;

  @override
  State<UiPageCounterTest> createState() => _UiTestState();
}

class _UiTestState extends State<UiPageCounterTest> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text('Counter test with id ${widget.id}'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
