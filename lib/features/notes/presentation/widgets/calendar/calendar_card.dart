import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/features/notes/domain/calendar_view_mode.dart';
import 'package:frontend/features/notes/domain/entities/note.dart';
import 'package:frontend/features/notes/presentation/notifiers/notes_notifier.dart';
import 'package:frontend/features/notes/presentation/notifiers/providers/calendar_notes_provider.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarCard extends ConsumerWidget {
  const CalendarCard({super.key});

  bool hasTasksForDay(DateTime day, List<Note> notes) =>
      notes.any((n) => isSameDay(n.dueDate, day));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider).value ?? [];

    final selectedDay = ref.watch(calendarSelectedDateProvider);
    final focusedDay = ref.watch(calendarFocusedDateProvider);
    final viewMode = ref.watch(calendarViewModeStateProvider);

    final colors = AppColors.of(context);
    final textTheme = context.textTheme;

    final dayStyle = (textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: colors.textPrimary,
      fontWeight: FontWeight.w400,
    );
    final selectedDayStyle = (textTheme.bodyMedium ?? const TextStyle())
        .copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        );
    final todayStyle = (textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
    );
    final dowStyle = (textTheme.labelSmall ?? const TextStyle()).copyWith(
      color: AppColors.calendarDayOfWeek,
      fontWeight: FontWeight.w600,
    );
    final headerStyle = (textTheme.titleMedium ?? const TextStyle()).copyWith(
      color: colors.textPrimary,
    );

    return Container(
      padding: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar<dynamic>(
        firstDay: DateTime.utc(2020),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        calendarFormat: viewMode.calendarFormat ?? CalendarFormat.month,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: (selected, focused) {
          ref.read(calendarSelectedDateProvider.notifier).setDate(selected);
          ref.read(calendarFocusedDateProvider.notifier).setDate(focused);
        },
        onPageChanged: (date) =>
            ref.read(calendarFocusedDateProvider.notifier).setDate(date),

        eventLoader: (day) => hasTasksForDay(day, notes) ? [true] : [],

        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleTextStyle: headerStyle,
          headerPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 8,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: colors.textSecondary,
            size: 20,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: colors.textSecondary,
            size: 20,
          ),
          leftChevronMargin: EdgeInsets.zero,
          rightChevronMargin: EdgeInsets.zero,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: dowStyle,
          weekendStyle: dowStyle,
        ),
        daysOfWeekHeight: 24,
        calendarStyle: CalendarStyle(
          cellMargin: const EdgeInsets.all(4),
          selectedDecoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          selectedTextStyle: selectedDayStyle,
          todayDecoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          todayTextStyle: todayStyle,
          defaultTextStyle: dayStyle,
          weekendTextStyle: dayStyle,
          outsideDaysVisible: false,

          // Стиль маркерів (крапок) під днями
          markerDecoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.7),
            shape: BoxShape.circle,
          ),
          markersMaxCount: 1,
          markerSize: 5,
          markerMargin: const EdgeInsets.only(top: 1),
        ),
      ),
    );
  }
}
