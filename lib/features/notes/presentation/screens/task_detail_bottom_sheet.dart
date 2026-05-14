import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/notes/domain/entities/task_list_model.dart';
import 'package:frontend/features/notes/presentation/screens/add_task_bottom_sheet.dart';
import 'package:frontend/i18n/strings.g.dart';

/// Bottom Sheet перегляду деталей завдання.
///
/// Показує всю інформацію про завдання у режимі читання.
/// Кнопка "Редагувати" відкриває [AddTaskBottomSheet] поверх цього sheet.
/// Після збереження змін оновлює дані і повідомляє батька через [onSaved].
///
/// Використання:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   barrierColor: Colors.black.withValues(alpha: 0.1),
///   builder: (_) => TaskDetailBottomSheet(
///     task: task,
///     listName: 'Work',
///     lists: _lists,
///     onSaved: (data) { /* apply changes */ },
///     onToggle: () { /* toggle completion */ },
///     onDelete: () { /* delete task */ },
///   ),
/// );
/// ```
class TaskDetailBottomSheet extends StatefulWidget {
  const TaskDetailBottomSheet({
    required this.task,
    required this.lists,
    required this.listName,
    required this.onSaved,
    required this.onToggle,
    required this.onDelete, super.key,
  });

  final TaskDetailData task;
  final List<TaskList> lists;
  final String listName;
  final void Function(TaskData data) onSaved;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  State<TaskDetailBottomSheet> createState() => _TaskDetailBottomSheetState();
}

class _TaskDetailBottomSheetState extends State<TaskDetailBottomSheet> {
  // Локальна копія щоб одразу показувати оновлені дані після редагування
  late TaskDetailData _task;
  QuillController? _readOnlyController;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _initQuillController();
  }

  void _initQuillController() {
    if (_task.subtitle.isEmpty) {
      _readOnlyController = null;
      return;
    }
    _readOnlyController = QuillController.basic();
    try {
      final decoded = jsonDecode(_task.subtitle) as List<dynamic>;
      _readOnlyController!.document = Document.fromJson(decoded);
    } on FormatException {
      _readOnlyController!.document = Document.fromJson([
        {'insert': '${_task.subtitle}\n'}
      ]);
    }
  }

  Future<void> _openEditSheet() async {
    final initialData = TaskData(
      title: _task.title,
      subtitle: _task.subtitle,
      dueDate: _task.dueDate,
      dueTime: _task.dueTime,
      listId: _task.listId,
      priority: _task.priority,
      reminderMinutesBefore: _task.reminderMinutesBefore,
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.15),
      builder: (_) => AddTaskBottomSheet(
        lists: widget.lists,
        initialData: initialData,
        onSaved: (data) {
          // Оновлюємо локальний стан — detail sheet одразу показує нові дані
          setState(() {
            _task = TaskDetailData(
              id: _task.id,
              title: data.title,
              subtitle: data.subtitle,
              dueDate: data.dueDate,
              dueTime: data.dueTime,
              listId: data.listId,
              priority: data.priority,
              reminderMinutesBefore: data.reminderMinutesBefore,
              isCompleted: _task.isCompleted,
            );
            _initQuillController();
          });
          // Передає зміни батьку
          widget.onSaved(data);
        },
      ),
    );
  }

  Future<void> _confirmAndDelete() async {
    final confirmed = await _confirmDelete(context);
    if (confirmed && mounted) {
      Navigator.of(context).pop();
      widget.onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final t = context.t;

    // Поточна назва списку — береться зі списків або передається ззовні
    final listName = widget.lists
        .where((l) => l.id == _task.listId)
        .firstOrNull
        ?.name ??
        widget.listName;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            const SizedBox(height: 12),
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
            const SizedBox(height: 16),

            // Заголовок sheet + кнопки дій
            Row(
              children: [
                // Чекбокс завершення
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _task = _task.copyWith(
                          isCompleted: !_task.isCompleted);
                    });
                    widget.onToggle();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _task.isCompleted
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                    child: _task.isCompleted
                        ? Icon(Icons.check,
                        size: 16, color: colors.surface)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),

                // Назва завдання
                Expanded(
                  child: Text(
                    _task.title,
                    style: textTheme.titleLarge?.copyWith(
                      decoration: _task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: _task.isCompleted
                          ? colors.textSecondary
                          : colors.textPrimary,
                    ),
                  ),
                ),

                // Кнопка редагувати
                IconButton(
                  onPressed: _openEditSheet,
                  icon: const Icon(Icons.edit_outlined,
                      color: AppColors.primary, size: 22),
                  tooltip: t.home.editTask,
                  visualDensity: VisualDensity.compact,
                ),

                // Кнопка видалити
                IconButton(
                  onPressed: _confirmAndDelete,
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.error, size: 22),
                  tooltip: t.home.deleteTask,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: colors.divider, height: 1),
            const SizedBox(height: 16),

            // Деталі (опис)
            if (_task.subtitle.isNotEmpty && _readOnlyController != null) ...[
              _DetailSection(
                icon: Icons.notes_outlined,
                child: AbsorbPointer(
                  child: QuillEditor.basic(
                    controller: _readOnlyController!,
                    config: QuillEditorConfig(
                      showCursor: false,
                      customStyles: DefaultStyles(
                        paragraph: DefaultTextBlockStyle(
                          textTheme.bodyLarge!.copyWith(
                            color: colors.textPrimary,
                            height: 1.5,
                          ),
                          HorizontalSpacing.zero,
                          VerticalSpacing.zero,
                          VerticalSpacing.zero,
                          null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Дата та час
            if (_task.dueDate != null) ...[
              _DetailSection(
                icon: Icons.calendar_today_outlined,
                child: Text(
                  _formatDateTime(_task.dueDate!, _task.dueTime, t),
                  style: textTheme.bodyLarge?.copyWith(
                      color: colors.textPrimary),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Список
            if (listName.isNotEmpty) ...[
              _DetailSection(
                icon: Icons.folder_outlined,
                child: Text(
                  listName,
                  style: textTheme.bodyLarge?.copyWith(
                      color: colors.textPrimary),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Пріоритет
            if (_task.priority != TaskPriority.none) ...[
              _DetailSection(
                icon: Icons.flag_outlined,
                iconColor: _task.priority.color,
                child: Text(
                  _task.priority.label(t),
                  style: textTheme.bodyLarge?.copyWith(
                    color: _task.priority.color,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Нагадування
            if (_task.reminderMinutesBefore != null) ...[
              _DetailSection(
                icon: Icons.notifications_outlined,
                child: Text(
                  _reminderLabel(_task.reminderMinutesBefore!, t),
                  style: textTheme.bodyLarge?.copyWith(
                      color: colors.textPrimary),
                ),
              ),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

// Рядок деталі (іконка + контент)

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.icon,
    required this.child,
    this.iconColor,
  });

  final IconData icon;
  final Widget child;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: iconColor ?? colors.textSecondary,
        ),
        const SizedBox(width: 12),
        Expanded(child: child),
      ],
    );
  }
}

// Модель даних для detail sheet

/// Дані завдання для відображення в [TaskDetailBottomSheet].
/// Містить ті самі поля, що й [TaskData], плюс [id] та [isCompleted].
class TaskDetailData {
  const TaskDetailData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.dueDate,
    this.dueTime,
    this.listId,
    this.priority = TaskPriority.none,
    this.reminderMinutesBefore,
  });

  final String id;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final DateTime? dueDate;
  final TimeOfDay? dueTime;
  final String? listId;
  final TaskPriority priority;
  final int? reminderMinutesBefore;

  TaskDetailData copyWith({
    String? title,
    String? subtitle,
    bool? isCompleted,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    String? listId,
    TaskPriority? priority,
    int? reminderMinutesBefore,
  }) =>
      TaskDetailData(
        id: id,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        isCompleted: isCompleted ?? this.isCompleted,
        dueDate: dueDate ?? this.dueDate,
        dueTime: dueTime ?? this.dueTime,
        listId: listId ?? this.listId,
        priority: priority ?? this.priority,
        reminderMinutesBefore:
        reminderMinutesBefore ?? this.reminderMinutesBefore,
      );
}

// Хелпери

String _formatDateTime(
    DateTime date, TimeOfDay? time, Translations t) {
  final monthName = t.calendar.months[date.month - 1];
  final dateStr = '${date.day} $monthName ${date.year}';
  if (time == null) return dateStr;
  final h = time.hour.toString().padLeft(2, '0');
  final m = time.minute.toString().padLeft(2, '0');
  return '$dateStr  $h:$m';
}

String _reminderLabel(int minutes, Translations t) {
  if (minutes == 0) return t.task.reminderAtTime;
  if (minutes < 60) return t.task.reminderMinutes(n: minutes);
  if (minutes < 1440) return t.task.reminderHours(n: minutes ~/ 60);
  return t.task.reminderDays(n: minutes ~/ 1440);
}

Future<bool> _confirmDelete(BuildContext context) async {
  final textTheme = Theme.of(context).textTheme;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      final t = ctx.t;
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        actionsAlignment: MainAxisAlignment.center,
        title: Text(
          t.home.deleteTask,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge,
        ),
        content: Text(t.home.deleteTaskMessage,
            textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
                foregroundColor: AppColors.error),
            child: Text(t.common.delete),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
