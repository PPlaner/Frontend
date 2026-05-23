import 'package:flutter/material.dart';
import 'package:frontend/core/presentation/theme/app_colors.dart';
import 'package:frontend/i18n/strings.g.dart';

enum TaskPriority { none, low, medium, high }

extension TaskPriorityExt on TaskPriority {
  String label(Translations t) {
    switch (this) {
      case TaskPriority.none:
        return t.task.priorityNone;
      case TaskPriority.low:
        return t.task.priorityLow;
      case TaskPriority.medium:
        return t.task.priorityMedium;
      case TaskPriority.high:
        return t.task.priorityHigh;
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.none:
        return AppColors.calendarDayOfWeek;
      case TaskPriority.low:
        return const Color(0xFF4CAF50);
      case TaskPriority.medium:
        return const Color(0xFFFFA726);
      case TaskPriority.high:
        return const Color(0xFFEF5350);
    }
  }
}
