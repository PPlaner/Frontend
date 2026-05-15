import 'package:flutter/material.dart';
import 'package:frontend/i18n/strings.g.dart';
import 'package:table_calendar/table_calendar.dart';

enum CalendarViewMode { month, twoWeeks, week, day }

extension CalendarViewModeExt on CalendarViewMode {
  String label(Translations t) {
    switch (this) {
      case CalendarViewMode.month:
        return t.calendar.viewMonth;
      case CalendarViewMode.twoWeeks:
        return t.calendar.viewTwoWeeks;
      case CalendarViewMode.week:
        return t.calendar.viewWeek;
      case CalendarViewMode.day:
        return t.calendar.viewDay;
    }
  }

  IconData get icon {
    switch (this) {
      case CalendarViewMode.month:
        return Icons.calendar_view_month_outlined;
      case CalendarViewMode.twoWeeks:
        return Icons.calendar_view_week_outlined;
      case CalendarViewMode.week:
        return Icons.calendar_view_week_outlined;
      case CalendarViewMode.day:
        return Icons.calendar_view_day_outlined;
    }
  }

  CalendarFormat? get calendarFormat {
    switch (this) {
      case CalendarViewMode.month:
        return CalendarFormat.month;
      case CalendarViewMode.twoWeeks:
        return CalendarFormat.twoWeeks;
      case CalendarViewMode.week:
        return CalendarFormat.week;
      case CalendarViewMode.day:
        return null;
    }
  }
}
