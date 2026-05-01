import 'package:flutter/widgets.dart';

class SafeChildScroll extends StatelessWidget {
  const SafeChildScroll({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: child,
      ),
    );
  }
}
