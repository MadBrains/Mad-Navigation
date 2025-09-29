import 'package:flutter/material.dart';
import 'package:tab_navigation_example/main.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    this.actions,
    required this.body,
    this.floatingActionButton,
    this.bottomAppBar,
  });

  final Widget title;
  final List<Widget>? actions;
  final Widget body;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? bottomAppBar;

  @override
  Widget build(BuildContext context) {
    final Widget? leading = !navigationService.state.canPop
        ? null
        : IconButton(
            onPressed: navigationService.pop,
            icon: const Icon(Icons.arrow_back_ios_new),
          );

    return Scaffold(
      appBar: AppBar(
        leading: leading,
        automaticallyImplyLeading: leading != null,
        title: title,
        actions: actions,
        bottom: bottomAppBar,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
