import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/features/notes/domain/calendar_view_mode.dart';
import 'package:frontend/features/notes/domain/constants.dart';
import 'package:frontend/features/notes/domain/entities/project.dart';
import 'package:frontend/features/notes/presentation/notifiers/projects_notifier.dart';
import 'package:frontend/features/notes/presentation/notifiers/providers/calendar_notes_provider.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:frontend/features/notes/presentation/screens/add_task_bottom_sheet.dart';
import 'package:frontend/features/notes/presentation/widgets/bottom_nav.dart';
import 'package:frontend/features/notes/presentation/widgets/calendar/calendar_card.dart';
import 'package:frontend/features/notes/presentation/widgets/calendar/day_header.dart';
import 'package:frontend/features/notes/presentation/widgets/calendar/list_filter_sheet.dart';
import 'package:frontend/features/notes/presentation/widgets/calendar/task_list_view.dart';
import 'package:frontend/features/notes/presentation/widgets/calendar/view_mode_sheet.dart';
import 'package:frontend/i18n/strings.g.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({
    super.key,
  });

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  String _filterLabel(
    List<Project> allProjects,
    String selectedProjectId,
  ) {
    if (selectedProjectId == allProjectsId) return context.t.calendar.filter;

    final list = allProjects
        .where((p) => p.id == selectedProjectId)
        .firstOrNull;

    return list?.title ?? context.t.calendar.filter;
  }

  Future<void> _openViewModePicker() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const ViewModeSheet(),
    );
  }

  Future<void> _openFilterSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const ListFilterSheet(),
    );
  }

  Future<void> _openAddTaskSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddTaskBottomSheet(),
      ),
    );
  }

  // Build

  @override
  Widget build(BuildContext context) {
    final allLists = ref.watch(projectsProvider).value ?? [];

    final calendarNotes = ref.watch(calendarNotesProvider);

    final selectedProjectId = ref.watch(selectedProjectIdProvider);
    final showDescription = ref.watch(showDescriptionProvider);
    final viewMode = ref.watch(calendarViewModeStateProvider);

    final colors = AppColors.of(context);
    final t = context.t;
    final isFilterActive = selectedProjectId != allProjectsId;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Розмитий логотип — тільки коли немає завдань на цей день
            if (calendarNotes.isEmpty)
              Positioned.fill(
                bottom: 110,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Opacity(
                      opacity: 0.25,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppAssets.logo,
                            height: 159,
                            width: 168,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            Column(
              children: [
                // Верхній рядок
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Кнопка режиму перегляду
                      IconButton(
                        icon: Icon(
                          viewMode.icon,
                          color: colors.textPrimary,
                          size: 24,
                        ),
                        tooltip: viewMode.label(t),
                        onPressed: _openViewModePicker,
                      ),
                      // Фільтр по списку — показує назву активного списку
                      if (isFilterActive)
                        GestureDetector(
                          onTap: _openFilterSheet,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _filterLabel(allLists, selectedProjectId),
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(color: AppColors.primary),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),

                      // Права частина — вигляд списку + фільтр
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Перемикач показу опису завдань
                          IconButton(
                            icon: Icon(
                              showDescription
                                  ? Icons.short_text_rounded
                                  : Icons.subject_rounded,
                              color: showDescription
                                  ? AppColors.primary
                                  : colors.textPrimary,
                              size: 24,
                            ),
                            tooltip: showDescription
                                ? t.calendar.hideDescription
                                : t.calendar.showDescription,
                            onPressed: () => ref
                                .read(showDescriptionProvider.notifier)
                                .toggle(),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.filter_alt_outlined,
                              color: isFilterActive
                                  ? AppColors.primary
                                  : colors.textPrimary,
                              size: 24,
                            ),
                            tooltip: t.calendar.filter,
                            onPressed: _openFilterSheet,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Календар або заголовок дня
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: viewMode == CalendarViewMode.day
                      ? const DayHeader()
                      : const CalendarCard(),
                ),

                const SizedBox(height: 16),

                // Список завдань
                Expanded(
                  child: calendarNotes.isNotEmpty
                      ? const TaskListView()
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskSheet,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.of(context).surface,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
