import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/notes/presentation/screens/add_task_bottom_sheet.dart';
import 'package:frontend/i18n/strings.g.dart';
import 'package:table_calendar/table_calendar.dart';

// Моделі

enum TaskCategory { all, work, personal, health, other }

extension TaskCategoryLabel on TaskCategory {
  String label(Translations t) {
    switch (this) {
      case TaskCategory.all:      return t.category.all;
      case TaskCategory.work:     return t.category.work;
      case TaskCategory.personal: return t.category.personal;
      case TaskCategory.health:   return t.category.health;
      case TaskCategory.other:    return t.category.other;
    }
  }
}

enum CalendarViewMode { month, twoWeeks, week, day }

extension CalendarViewModeExt on CalendarViewMode {
  String label(Translations t) {
    switch (this) {
      case CalendarViewMode.month:    return t.calendar.viewMonth;
      case CalendarViewMode.twoWeeks: return t.calendar.viewTwoWeeks;
      case CalendarViewMode.week:     return t.calendar.viewWeek;
      case CalendarViewMode.day:      return t.calendar.viewDay;
    }
  }

  IconData get icon {
    switch (this) {
      case CalendarViewMode.month:    return Icons.calendar_view_month_outlined;
      case CalendarViewMode.twoWeeks: return Icons.calendar_view_week_outlined;
      case CalendarViewMode.week:     return Icons.calendar_view_week_outlined;
      case CalendarViewMode.day:      return Icons.calendar_view_day_outlined;
    }
  }

  CalendarFormat? get calendarFormat {
    switch (this) {
      case CalendarViewMode.month:    return CalendarFormat.month;
      case CalendarViewMode.twoWeeks: return CalendarFormat.twoWeeks;
      case CalendarViewMode.week:     return CalendarFormat.week;
      case CalendarViewMode.day:      return null;
    }
  }
}

// Зробити: перенести в domain/entities/ після підключення Riverpod
class CalendarTaskItem {
  CalendarTaskItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.category,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final DateTime date;
  final TaskCategory category;
  bool isCompleted;
}

// CalendarScreen

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Зробити: замінити на Riverpod провайдер
  final List<CalendarTaskItem> _tasks = [];

  int _currentNavIndex = 1;
  CalendarViewMode _viewMode = CalendarViewMode.month;
  TaskCategory _selectedCategory = TaskCategory.all;
  bool _completedExpanded = true;

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Геттери

  List<CalendarTaskItem> get _filteredTasks {
    return _tasks.where((task) {
      final isSameDate = isSameDay(task.date, _selectedDay);
      final matchesCategory = _selectedCategory == TaskCategory.all ||
          task.category == _selectedCategory;
      return isSameDate && matchesCategory;
    }).toList();
  }

  List<CalendarTaskItem> get _activeTasks =>
      _filteredTasks.where((t) => !t.isCompleted).toList();

  List<CalendarTaskItem> get _completedTasks =>
      _filteredTasks.where((t) => t.isCompleted).toList();

  bool get _hasTasksForSelectedDay => _filteredTasks.isNotEmpty;

  // Дії

  void _toggleTask(CalendarTaskItem task) {
    setState(() => task.isCompleted = !task.isCompleted);
  }

  void _deleteTask(CalendarTaskItem task) {
    setState(() => _tasks.removeWhere((t) => t.id == task.id));
  }

  Future<void> _openViewModePicker() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ViewModeSheet(
        current: _viewMode,
        onSelected: (mode) {
          setState(() => _viewMode = mode);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _openFilterSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _FilterSheet(
        current: _selectedCategory,
        onSelected: (cat) {
          setState(() => _selectedCategory = cat);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _openAddTaskSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => AddTaskBottomSheet(
        onTaskAdded: (title, subtitle) {
          setState(() {
            _tasks.add(CalendarTaskItem(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: title,
              subtitle: subtitle,
              date: _selectedDay,
              category: _selectedCategory == TaskCategory.all
                  ? TaskCategory.work
                  : _selectedCategory,
            ));
          });
        },
      ),
    );
  }

  String _formatDayTitle(DateTime date, Translations t) {
    return '${date.day} ${t.calendar.months[date.month - 1]} ${date.year}';
  }

  // Build

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final t = context.t;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Розмитий логотип — тільки коли немає завдань на цей день
            if (!_hasTasksForSelectedDay)
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
                          const SizedBox(height: 16),
                          Text(
                            t.calendar.noTasks,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: colors.textSecondary,
                            ),
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
                      IconButton(
                        icon: Icon(
                          _viewMode.icon,
                          color: colors.textPrimary,
                          size: 24,
                        ),
                        tooltip: _viewMode.label(t),
                        onPressed: _openViewModePicker,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.filter_alt_outlined,
                          color: _selectedCategory != TaskCategory.all
                              ? AppColors.primary
                              : colors.textPrimary,
                          size: 24,
                        ),
                        tooltip: t.calendar.filter,
                        onPressed: _openFilterSheet,
                      ),
                    ],
                  ),
                ),

                // Календар або заголовок дня
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _viewMode == CalendarViewMode.day
                      ? _DayHeader(
                    date: _selectedDay,
                    title: _formatDayTitle(_selectedDay, t),
                    onPrev: () => setState(() {
                      _selectedDay = _selectedDay
                          .subtract(const Duration(days: 1));
                      _focusedDay = _selectedDay;
                    }),
                    onNext: () => setState(() {
                      _selectedDay =
                          _selectedDay.add(const Duration(days: 1));
                      _focusedDay = _selectedDay;
                    }),
                  )
                      : _CalendarCard(
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    viewMode: _viewMode,
                    textTheme: Theme.of(context).textTheme,
                    onDaySelected: (selected, focused) {
                      setState(() {
                        _selectedDay = selected;
                        _focusedDay = focused;
                      });
                    },
                    onPageChanged: (focused) {
                      setState(() => _focusedDay = focused);
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Список завдань
                Expanded(
                  child: _hasTasksForSelectedDay
                      ? _buildTaskContent()
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
        foregroundColor: colors.surface,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
      ),
    );
  }

  // Будує список активних + секцію завершених
  Widget _buildTaskContent() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      children: [
        // Активні завдання
        ..._activeTasks.map(
              (task) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SwipableTaskCard(
              key: ValueKey(task.id),
              task: task,
              onToggle: () => _toggleTask(task),
              onDelete: () => _deleteTask(task),
            ),
          ),
        ),

        // Секція завершених — тільки якщо є хоча б одне
        if (_completedTasks.isNotEmpty) ...[
          const SizedBox(height: 4),
          _CompletedSection(
            isExpanded: _completedExpanded,
            count: _completedTasks.length,
            onToggle: () =>
                setState(() => _completedExpanded = !_completedExpanded),
            children: _completedTasks
                .map(
                  (task) => _SwipableCompletedTile(
                key: ValueKey(task.id),
                task: task,
                onToggle: () => _toggleTask(task),
                onDelete: () => _deleteTask(task),
              ),
            )
                .toList(),
          ),
        ],
      ],
    );
  }
}

// Активне завдання зі свайпом

class _SwipableTaskCard extends StatelessWidget {
  const _SwipableTaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  final CalendarTaskItem task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final t = context.t;

    return Dismissible(
      key: ValueKey('cal-dismissible-${task.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.deleteBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: AppColors.error,
          size: 24,
        ),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.cardBorder),
        ),
        child: ListTile(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          horizontalTitleGap: 8,
          leading: SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: task.isCompleted,
              onChanged: (_) => onToggle(),
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          title: Text(task.title, style: textTheme.titleMedium),
          subtitle: task.subtitle.isNotEmpty
              ? Text(
            task.subtitle,
            style: textTheme.bodySmall
                ?.copyWith(color: colors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
              : null,
          trailing: Text(task.category.label(t), style: textTheme.bodySmall),
        ),
      ),
    );
  }
}

// Завершене завдання зі свайпом

class _SwipableCompletedTile extends StatelessWidget {
  const _SwipableCompletedTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  final CalendarTaskItem task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final t = context.t;

    return Dismissible(
      key: ValueKey('cal-completed-${task.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.deleteBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: AppColors.error,
          size: 24,
        ),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Row(
          children: [
            // Натискання повертає в активні
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(Icons.check, size: 14, color: colors.surface),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.title,
                style: textTheme.titleMedium?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: colors.textSecondary,
                ),
              ),
            ),
            Text(task.category.label(t), style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

// Секція "Завершені"

class _CompletedSection extends StatelessWidget {
  const _CompletedSection({
    required this.isExpanded,
    required this.count,
    required this.onToggle,
    required this.children,
  });

  final bool isExpanded;
  final int count;
  final VoidCallback onToggle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final t = context.t;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Text(
                    t.home.completed,
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text('$count', style: textTheme.bodySmall),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: isExpanded ? 0 : -0.5,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Column(children: children),
            secondChild: const SizedBox.shrink(),
            crossFadeState: isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

// Діалог підтвердження видалення

Future<bool> _confirmDelete(BuildContext context) async {
  final textTheme = Theme.of(context).textTheme;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      final t = ctx.t;
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actionsAlignment: MainAxisAlignment.center,
        title: Text(
          t.home.deleteTask,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge,
        ),
        content: Text(
          t.home.deleteTaskMessage,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text(t.common.delete),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

// Картка з TableCalendar

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.focusedDay,
    required this.selectedDay,
    required this.viewMode,
    required this.textTheme,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;
  final CalendarViewMode viewMode;
  final TextTheme textTheme;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(DateTime) onPageChanged;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Стилі для дат беремо з textTheme — єдине джерело правди
    final dayStyle = (textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: colors.textPrimary,
      fontWeight: FontWeight.w400,
    );
    final selectedDayStyle = (textTheme.bodyMedium ?? const TextStyle()).copyWith(
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
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        calendarFormat: viewMode.calendarFormat ?? CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleTextStyle: headerStyle,
          headerPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
        ),
      ),
    );
  }
}

// Заголовок режиму "День"

class _DayHeader extends StatelessWidget {
  const _DayHeader({
    required this.date,
    required this.title,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime date;
  final String title;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
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
            onTap: onPrev,
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
            onTap: onNext,
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

// Bottom Sheet: режим перегляду

class _ViewModeSheet extends StatelessWidget {
  const _ViewModeSheet({
    required this.current,
    required this.onSelected,
  });

  final CalendarViewMode current;
  final ValueChanged<CalendarViewMode> onSelected;

  @override
  Widget build(BuildContext context) {
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
                  color: current == mode
                      ? AppColors.primary
                      : colors.textSecondary,
                ),
                title: Text(
                  mode.label(t),
                  style: textTheme.titleMedium?.copyWith(
                    color: current == mode
                        ? AppColors.primary
                        : colors.textSecondary,
                  ),
                ),
                trailing: current == mode
                    ? const Icon(
                  Icons.check,
                  color: AppColors.primary,
                  size: 20,
                )
                    : null,
                onTap: () => onSelected(mode),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// Bottom Sheet: фільтр категорій

class _FilterSheet extends StatelessWidget {
  const _FilterSheet({
    required this.current,
    required this.onSelected,
  });

  final TaskCategory current;
  final ValueChanged<TaskCategory> onSelected;

  @override
  Widget build(BuildContext context) {
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
            Text(t.calendar.taskCategory, style: textTheme.titleLarge),
            const SizedBox(height: 16),
            ...TaskCategory.values.map(
                  (cat) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  cat.label(t),
                  style: textTheme.titleMedium?.copyWith(
                    color: current == cat
                        ? AppColors.primary
                        : colors.textPrimary,
                  ),
                ),
                trailing: current == cat
                    ? const Icon(
                  Icons.check,
                  color: AppColors.primary,
                  size: 20,
                )
                    : null,
                onTap: () => onSelected(cat),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// Bottom Navigation Bar

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final t = context.t;

    return Container(
      decoration: BoxDecoration(
        color: colors.bottomNav,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: colors.textPrimary,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.check_box_outlined),
            label: t.bottomNav.tasks,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month),
            label: t.bottomNav.calendar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: t.bottomNav.profile,
          ),
        ],
      ),
    );
  }
}