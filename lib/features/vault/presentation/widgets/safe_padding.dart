import 'package:flutter/widgets.dart';

class SafePadding extends StatelessWidget {
  const SafePadding({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: child,
      ),
    );
  }
}
