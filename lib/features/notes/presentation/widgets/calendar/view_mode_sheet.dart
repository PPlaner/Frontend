import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/features/notes/domain/calendar_view_mode.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:frontend/i18n/strings.g.dart';

class ViewModeSheet extends ConsumerWidget {
  const ViewModeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(calendarViewModeStateProvider);

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
                  color: context.theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(t.calendar.calendarView, style: context.textTheme.titleLarge),

            const SizedBox(height: 16),

            ...CalendarViewMode.values.map(
              (mode) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  mode.icon,
                  color: viewMode == mode
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurface,
                ),
                title: Text(
                  mode.label(t),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: viewMode == mode
                        ? context.colorScheme.primary
                        : context.theme.hintColor,
                  ),
                ),
                trailing: viewMode == mode
                    ? Icon(
                        Icons.check,
                        color: context.colorScheme.primary,
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
