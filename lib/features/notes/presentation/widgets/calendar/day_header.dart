import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:frontend/i18n/strings.g.dart';

class DayHeader extends ConsumerWidget {
  const DayHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(calendarSelectedDateProvider);
    final title = _formatDayTitle(selectedDate, context.t);

    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              ref
                  .read(calendarSelectedDateProvider.notifier)
                  .setDate(selectedDate.subtract(const Duration(days: 1)));
              ref
                  .read(calendarFocusedDateProvider.notifier)
                  .setDate(selectedDate.subtract(const Duration(days: 1)));
            },
            child: Icon(
              Icons.chevron_left,
              color: colors.textSecondary,
              size: 20,
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium,
            ),
          ),
          GestureDetector(
            onTap: () {
              ref
                  .read(calendarSelectedDateProvider.notifier)
                  .setDate(selectedDate.add(const Duration(days: 1)));
              ref
                  .read(calendarFocusedDateProvider.notifier)
                  .setDate(selectedDate.add(const Duration(days: 1)));
            },
            child: Icon(
              Icons.chevron_right,
              color: colors.textSecondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDayTitle(DateTime date, Translations t) {
  return '${date.day} ${t.calendar.months[date.month - 1]} ${date.year}';
}
