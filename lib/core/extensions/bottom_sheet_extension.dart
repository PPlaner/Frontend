import 'package:flutter/material.dart';

extension BottomSheetExtension on BuildContext {
  Future<T?> showAppBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = true,
    bool useSafeArea = true,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      elevation: 0,
      useSafeArea: useSafeArea,
      builder: (context) {
        return child;
      },
    );
  }
}
