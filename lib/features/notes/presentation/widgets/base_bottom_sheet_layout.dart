import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/features/notes/presentation/widgets/bottom_sheet_drag_handle.dart';

class BaseBottomSheetLayout extends StatelessWidget {
  const BaseBottomSheetLayout({
    required this.children,
    this.header,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 16),
    this.padForKeyboard = false,
    super.key,
  });

  final List<Widget> children;
  final Widget? header;
  final EdgeInsets padding;
  final bool padForKeyboard;

  @override
  Widget build(BuildContext context) {
    final bottomInset = padForKeyboard
        ? MediaQuery.viewInsetsOf(context).bottom
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: context.customColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: padding.add(EdgeInsets.only(bottom: bottomInset)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BottomSheetDragHandle(),
              const SizedBox(height: 16),

              if (header != null) ...[header!, const SizedBox(height: 8)],

              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
