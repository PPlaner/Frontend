import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/features/notes/presentation/screens/add_task_bottom_sheet.dart';
import 'package:frontend/i18n/strings.g.dart';

// Модель завдання
// Перенести в domain/entities/ коли буде підключено Riverpod

class TaskItem {
  TaskItem({
    required this.id,
    required this.title,
    required this.dateLabel,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String dateLabel;
  bool isCompleted;
}

// HomeScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Замінити на Riverpod провайдер
  final List<TaskItem> _tasks = [];

  int _currentNavIndex = 0;
  bool _completedExpanded = true;
  bool _isBottomSheetOpen = false;

  List<TaskItem> get _activeTasks => _tasks.where((t) => !t.isCompleted).toList();
  List<TaskItem> get _completedTasks => _tasks.where((t) => t.isCompleted).toList();
  bool get _hasTasks => _tasks.isNotEmpty;

  void _toggleTask(TaskItem task) {
    setState(() => task.isCompleted = !task.isCompleted);
  }

  void _deleteTask(TaskItem task) {
    setState(() => _tasks.removeWhere((t) => t.id == task.id));
  }

  void _addTask(String title, String subtitle) {
    setState(() {
      _tasks.add(TaskItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        // subtitle поки зберігаємо як dateLabel-заглушку
        // Зробити: окреме поле subtitle в моделі після підключення Riverpod
        dateLabel: context.t.home.today,
      ));
    });
  }

  void _openAddTask() {
    setState(() => _isBottomSheetOpen = true);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Прозорий бар'єр — blur робимо самі через Stack
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (_) => AddTaskBottomSheet(onTaskAdded: _addTask),
    ).whenComplete(() {
      setState(() => _isBottomSheetOpen = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // Основний контент
          Column(
            children: [
              AppBar(
                leading: IconButton(
                  icon: Icon(Icons.menu, color: colors.textPrimary),
                  onPressed: () {},
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _hasTasks
                      ? _TaskListView(
                    key: const ValueKey('list'),
                    activeTasks: _activeTasks,
                    completedTasks: _completedTasks,
                    completedExpanded: _completedExpanded,
                    onToggleTask: _toggleTask,
                    onDeleteTask: _deleteTask,
                    onToggleCompleted: () => setState(
                          () => _completedExpanded = !_completedExpanded,
                    ),
                  )
                      : const _EmptyStateView(key: ValueKey('empty')),
                ),
              ),
            ],
          ),

          // Blur overlay при відкритому bottom sheet
          if (_isBottomSheetOpen)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: Colors.black.withOpacity(0.08),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTask,
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
}

// Порожній стан (Головна 1)

class _EmptyStateView extends StatelessWidget {
  const _EmptyStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.45,
        child: SizedBox(
          width: 168,
          height: 159,
          child: Stack(
            alignment: Alignment.center,
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
    );
  }
}

// Список завдань (Головна 2)

class _TaskListView extends StatelessWidget {
  const _TaskListView({
    super.key,
    required this.activeTasks,
    required this.completedTasks,
    required this.completedExpanded,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onToggleCompleted,
  });

  final List<TaskItem> activeTasks;
  final List<TaskItem> completedTasks;
  final bool completedExpanded;
  final ValueChanged<TaskItem> onToggleTask;
  final ValueChanged<TaskItem> onDeleteTask;
  final VoidCallback onToggleCompleted;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final t = context.t;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      children: [
        Text(t.home.today, style: textTheme.displayLarge),
        const SizedBox(height: 16),

        // Активні завдання — свайп вліво для видалення
        ...activeTasks.map(
              (task) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SwipableTaskCard(
              key: ValueKey(task.id),
              task: task,
              onToggle: () => onToggleTask(task),
              onDelete: () => onDeleteTask(task),
            ),
          ),
        ),

        // Секція завершених
        if (completedTasks.isNotEmpty) ...[
          const SizedBox(height: 4),
          _CompletedSection(
            isExpanded: completedExpanded,
            count: completedTasks.length,
            onToggle: onToggleCompleted,
            children: completedTasks
                .map(
                  (task) => _SwipableCompletedTile(
                key: ValueKey(task.id),
                task: task,
                onToggle: () => onToggleTask(task),
                onDelete: () => onDeleteTask(task),
              ),
            )
                .toList(),
          ),
        ],
      ],
    );
  }
}

// Активне завдання зі свайпом для видалення

class _SwipableTaskCard extends StatelessWidget {
  const _SwipableTaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  final TaskItem task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Dismissible(
      key: ValueKey('dismissible-${task.id}'),
      direction: DismissDirection.endToStart,
      // Червоний фон з іконкою кошика при свайпі
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 10),
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
      // Підтвердження видалення
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => onToggle(),
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.title,
                  style: textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(task.dateLabel, style: textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

// Завершене завдання зі свайпом і можливістю зняти галочку

class _SwipableCompletedTile extends StatelessWidget {
  const _SwipableCompletedTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  final TaskItem task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Dismissible(
      key: ValueKey('dismissible-${task.id}'),
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
            // Галочка — натискання повертає завдання в активні
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
            Text(task.dateLabel, style: textTheme.bodySmall),
          ],
        ),
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
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(t.common.delete),
          ),
        ],
      );
    },
  );
  return result ?? false;
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  const SizedBox(width: 6),
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
            icon: const Icon(Icons.calendar_month_outlined),
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
