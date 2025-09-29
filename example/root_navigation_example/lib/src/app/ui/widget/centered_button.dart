import 'package:flutter/material.dart';

class CenteredButton extends StatelessWidget {
  const CenteredButton({required this.child, required this.onPressed});

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(child: ElevatedButton(onPressed: onPressed, child: child));
  }
}
