import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/notes/domain/calendar_view_mode.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:frontend/i18n/strings.g.dart';

class ViewModeSheet extends ConsumerWidget {
  const ViewModeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(calendarViewModeStateProvider);

    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final t = context.t;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(t.calendar.calendarView, style: textTheme.titleLarge),

            const SizedBox(height: 16),

            ...CalendarViewMode.values.map(
              (mode) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  mode.icon,
                  color: viewMode == mode
                      ? AppColors.primary
                      : colors.textSecondary,
                ),
                title: Text(
                  mode.label(t),
                  style: textTheme.titleMedium?.copyWith(
                    color: viewMode == mode
                        ? AppColors.primary
                        : colors.textSecondary,
                  ),
                ),
                trailing: viewMode == mode
                    ? const Icon(
                        Icons.check,
                        color: AppColors.primary,
                        size: 20,
                      )
                    : null,
                onTap: () => ref
                    .read(calendarViewModeStateProvider.notifier)
                    .setMode(mode),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
