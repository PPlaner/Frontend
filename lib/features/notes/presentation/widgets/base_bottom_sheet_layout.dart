import 'package:flutter/material.dart';
import 'package:frontend/core/presentation/theme/theme_extensions.dart';

class BaseBottomSheetLayout extends StatelessWidget {
  const BaseBottomSheetLayout({
    required this.children,
    this.header,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 16),
    this.padForKeyboard = false,
    this.showDivider = false,
    super.key,
  });

  final List<Widget> children;
  final Widget? header;
  final EdgeInsets padding;
  final bool padForKeyboard;
  final bool showDivider;

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
              const _BottomSheetDragHandle(),
              const SizedBox(height: 16),

              if (header != null) ...[
                header!,
                const SizedBox(height: 8),
              ],

              if (showDivider) ...[
                Divider(color: context.theme.dividerColor, height: 1),
                const SizedBox(height: 12),
              ],

              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomSheetDragHandle extends StatelessWidget {
  const _BottomSheetDragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: context.theme.dividerColor,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
