import 'package:flutter/material.dart';
import 'package:root_navigation_example/main.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  final Widget title;
  final Widget body;
  final Widget? floatingActionButton;

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
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
