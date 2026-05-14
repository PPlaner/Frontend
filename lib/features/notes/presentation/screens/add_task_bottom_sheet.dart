import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/notes/domain/entities/task_list_model.dart';
import 'package:frontend/i18n/strings.g.dart';

// Пріоритети завдання

enum TaskPriority { none, low, medium, high }

extension TaskPriorityExt on TaskPriority {
  String label(Translations t) {
    switch (this) {
      case TaskPriority.none:   return t.task.priorityNone;
      case TaskPriority.low:    return t.task.priorityLow;
      case TaskPriority.medium: return t.task.priorityMedium;
      case TaskPriority.high:   return t.task.priorityHigh;
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.none:   return AppColors.calendarDayOfWeek;
      case TaskPriority.low:    return const Color(0xFF4CAF50);
      case TaskPriority.medium: return const Color(0xFFFFA726);
      case TaskPriority.high:   return const Color(0xFFEF5350);
    }
  }
}

// Дані завдання що передаються при збереженні

class TaskData {
  const TaskData({
    required this.title,
    required this.subtitle,
    this.dueDate,
    this.dueTime,
    this.listId,
    this.priority = TaskPriority.none,
    this.reminderMinutesBefore,
  });

  final String title;
  final String subtitle;
  final DateTime? dueDate;
  final TimeOfDay? dueTime;
  final String? listId;
  final TaskPriority priority;
  final int? reminderMinutesBefore; // null = без нагадування

  TaskData copyWith({
    String? title,
    String? subtitle,
    DateTime? dueDate,
    bool clearDueDate = false,
    TimeOfDay? dueTime,
    bool clearDueTime = false,
    String? listId,
    TaskPriority? priority,
    int? reminderMinutesBefore,
    bool clearReminder = false,
  }) =>
      TaskData(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
        dueTime: clearDueTime ? null : (dueTime ?? this.dueTime),
        listId: listId ?? this.listId,
        priority: priority ?? this.priority,
        reminderMinutesBefore:
        clearReminder ? null : (reminderMinutesBefore
            ?? this.reminderMinutesBefore),
      );
}

/// Bottom Sheet для додавання / редагування завдання.
///
/// Використання (нове завдання):
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   barrierColor: Colors.transparent,
///   builder: (_) => AddTaskBottomSheet(
///     lists: _lists,
///     onSaved: (data) { ... },
///   ),
/// );
/// ```
///
/// Використання (редагування):
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   barrierColor: Colors.transparent,
///   builder: (_) => AddTaskBottomSheet(
///     lists: _lists,
///     initialData: TaskData(title: task.title, subtitle: task.subtitle, ...),
///     onSaved: (data) { ... },
///   ),
/// );
/// ```
class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({
    required this.onSaved, super.key,
    this.lists = const [],
    this.initialData,
    this.onTaskAdded,
  });

  final void Function(TaskData data) onSaved;

  /// Якщо передано — режим редагування.
  final TaskData? initialData;

  /// Списки для вибору папки.
  final List<TaskList> lists;

  /// [Deprecated] Зворотна сумісність:
  /// старі виклики через onTaskAdded(title, subtitle).
  final void Function(String title, String subtitle)? onTaskAdded;

  bool get isEditing => initialData != null;

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  late final TextEditingController _titleController;
  late final QuillController _quillController;
  final FocusNode _titleFocus = FocusNode();

  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  String? _listId;
  TaskPriority _priority = TaskPriority.none;
  int? _reminderMinutesBefore;

  @override
  void initState() {
    super.initState();
    final init = widget.initialData;
    _titleController = TextEditingController(text: init?.title ?? '');
    _quillController = QuillController.basic();
    if (init != null && init.subtitle.isNotEmpty) {
      try {
        final decoded = jsonDecode(init.subtitle) as List<dynamic>;
        _quillController.document = Document.fromJson(decoded);
      } on FormatException {
        _quillController.document = Document.fromJson([
          {'insert': '${init.subtitle}\n'}
        ]);
      }
    }
    _dueDate = init?.dueDate;
    _dueTime = init?.dueTime;
    _listId  = init?.listId;
    _priority = init?.priority ?? TaskPriority.none;
    _reminderMinutesBefore = init?.reminderMinutesBefore;

    if (!widget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _titleFocus.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    _titleFocus.dispose();
    super.dispose();
  }

  void _onCancel() => Navigator.of(context).pop();

  void _onConfirm() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final plainText = _quillController.document.toPlainText().trim();
    final details = plainText.isEmpty
        ? ''
        : jsonEncode(_quillController.document.toDelta().toJson());

    final data = TaskData(
      title: title,
      subtitle: details,
      dueDate: _dueDate,
      dueTime: _dueTime,
      listId: _listId,
      priority: _priority,
      reminderMinutesBefore: _reminderMinutesBefore,
    );

    widget.onSaved(data);
    // Зворотна сумісність
    widget.onTaskAdded?.call(title, details);
    Navigator.of(context).pop();
  }

  // Пікери

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
            primary: AppColors.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    // Після вибору дати — запропонувати час
    if (!mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
            primary: AppColors.primary,
          ),
        ),
        child: child!,
      ),
    );
    setState(() {
      _dueDate = picked;
      _dueTime = pickedTime; // може бути null якщо скасовано
    });
  }

  Future<void> _pickList() async {
    if (widget.lists.isEmpty) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ListPickerSheet(
        lists: widget.lists,
        selectedListId: _listId,
        onSelected: (id) {
          setState(() => _listId = id);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _pickPriority() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _PriorityPickerSheet(
        current: _priority,
        onSelected: (p) {
          setState(() => _priority = p);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _pickReminder() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ReminderPickerSheet(
        current: _reminderMinutesBefore,
        onSelected: (minutes) {
          setState(() => _reminderMinutesBefore = minutes);
          Navigator.pop(context);
        },
      ),
    );
  }

  // Helpers

  String _dueDateLabel(Translations t) {
    if (_dueDate == null) return '';
    final d = _dueDate!;
    final dateStr = '${d.day} ${t.calendar.months[d.month - 1]}';
    if (_dueTime != null) {
      final h = _dueTime!.hour.toString().padLeft(2, '0');
      final m = _dueTime!.minute.toString().padLeft(2, '0');
      return '$dateStr $h:$m';
    }
    return dateStr;
  }

  String? _listName() {
    if (_listId == null) return null;
    return widget.lists
        .where((l) => l.id == _listId)
        .firstOrNull
        ?.name;
  }

  // Build

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final t = context.t;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(16, 0, 16, keyboardHeight + 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Рядок: ✕ | Заголовок | ✓
            Row(
              children: [
                GestureDetector(
                  onTap: _onCancel,
                  child: Icon(
                    Icons.cancel_outlined,
                    color: colors.textSecondary,
                    size: 24,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.isEditing ? t.home.editTask : t.home.newTask,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium,
                  ),
                ),
                GestureDetector(
                  onTap: _onConfirm,
                  child: const Icon(
                    Icons.check,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Поле вводу назви
            Container(
              height: 51,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: TextField(
                controller: _titleController,
                focusNode: _titleFocus,
                style: textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: t.home.whatToDo,
                  hintStyle: textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                  filled: true,
                  fillColor: colors.surface,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
            ),

            const SizedBox(height: 8),

            // Деталі + мета-іконки
            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quill editor
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 60,
                      maxHeight: 120,
                    ),
                    child: Builder(
                      builder: (context) {
                        final fontFamily = Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.fontFamily;
                        return QuillEditor.basic(
                          controller: _quillController,
                          config: QuillEditorConfig(
                            placeholder: t.home.addDetails,
                            customStyles: DefaultStyles(
                              placeHolder: DefaultTextBlockStyle(
                                TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: colors.textSecondary,
                                  height: 1.5,
                                ),
                                HorizontalSpacing.zero,
                                VerticalSpacing.zero,
                                VerticalSpacing.zero,
                                null,
                              ),
                              paragraph: DefaultTextBlockStyle(
                                TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
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
                        );
                      },
                    ),
                  ),

                  Divider(height: 16, color: colors.divider),

                  // Мета-іконки з активними значеннями
                  Center(
                  child:
                    Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 12,
                      children: [
                      // Календар
                      _MetaIconButton(
                        icon: Icons.calendar_today_outlined,
                        label: _dueDate != null ? _dueDateLabel(t) : null,
                        isActive: _dueDate != null,
                        onTap: _pickDate,
                        onClear: _dueDate != null
                            ? () => setState(() {
                          _dueDate = null;
                          _dueTime = null;
                        })
                            : null,
                      ),
                      const SizedBox(width: 16),
                      // Папка
                      _MetaIconButton(
                        icon: Icons.folder_outlined,
                        label: _listName(),
                        isActive: _listId != null,
                        onTap: _pickList,
                        onClear: _listId != null
                            ? () => setState(() => _listId = null)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      // Прапорець — пріоритет
                      _MetaIconButton(
                        icon: Icons.flag_outlined,
                        label: _priority != TaskPriority.none
                            ? _priority.label(t)
                            : null,
                        isActive: _priority != TaskPriority.none,
                        activeColor: _priority.color,
                        onTap: _pickPriority,
                        onClear: _priority != TaskPriority.none
                            ? () => setState(
                                () => _priority = TaskPriority.none)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      // Нагадування
                      _MetaIconButton(
                        icon: Icons.notifications_none_outlined,
                        label: _reminderMinutesBefore != null
                            ? _reminderLabel(_reminderMinutesBefore!, t)
                            : null,
                        isActive: _reminderMinutesBefore != null,
                        onTap: _pickReminder,
                        onClear: _reminderMinutesBefore != null
                            ? () => setState(
                                () => _reminderMinutesBefore = null)
                            : null,
                      ),
                    ],
                  ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Quill Toolbar
            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: QuillSimpleToolbar(
                controller: _quillController,
                config: const QuillSimpleToolbarConfig(
                  showStrikeThrough: false,
                  showColorButton: false,
                  showBackgroundColorButton: false,
                  showClearFormat: false,
                  showLink: false,
                  showHeaderStyle: false,
                  showCodeBlock: false,
                  showQuote: false,
                  showIndent: false,
                  showSearchButton: false,
                  showSubscript: false,
                  showSuperscript: false,
                  showDividers: false,
                  multiRowsDisplay: false,
                  toolbarIconAlignment: WrapAlignment.start,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Допоміжний хелпер для рядка нагадування

String _reminderLabel(int minutes, Translations t) {
  if (minutes == 0)   return t.task.reminderAtTime;
  if (minutes < 60)   return t.task.reminderMinutes(n: minutes);
  if (minutes < 1440) return t.task.reminderHours(n: minutes ~/ 60);
  return t.task.reminderDays(n: minutes ~/ 1440);
}

// Мета-іконка з опціональним лейблом і кнопкою очищення

class _MetaIconButton extends StatelessWidget {
  const _MetaIconButton({
    required this.icon,
    required this.onTap,
    this.label,
    this.isActive = false,
    this.activeColor,
    this.onClear,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? label;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
    isActive ? (activeColor ?? AppColors.primary) : AppColors.primary;

    if (label == null) {
      return GestureDetector(
        onTap: onTap,
        child: Icon(icon, size: 20, color: effectiveColor),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: effectiveColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: effectiveColor.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: effectiveColor),
            const SizedBox(width: 4),
            Text(
              label!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: effectiveColor,
              ),
            ),
            if (onClear != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.close, size: 12, color: effectiveColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Bottom Sheet: вибір списку

class _ListPickerSheet extends StatelessWidget {
  const _ListPickerSheet({
    required this.lists,
    required this.selectedListId,
    required this.onSelected,
  });

  final List<TaskList> lists;
  final String? selectedListId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final t = context.t;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
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
            const SizedBox(height: 16),
            Text(t.task.chooseList, style: textTheme.titleLarge),
            const SizedBox(height: 8),

            // Без списку
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Text('📋', style: TextStyle(fontSize: 20)),
              title: Text(
                t.task.noList,
                style: textTheme.titleMedium?.copyWith(
                  color: selectedListId == null
                      ? AppColors.primary
                      : colors.textPrimary,
                ),
              ),
              trailing: selectedListId == null
                  ? const Icon(Icons.check,
                  color: AppColors.primary, size: 20)
                  : null,
              onTap: () => onSelected(null),
            ),

            if (lists.isNotEmpty) Divider(color: colors.divider),

            ...lists.map(
                  (list) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text(list.emoji, style: const TextStyle(fontSize: 20)),
                title: Text(
                  list.name,
                  style: textTheme.titleMedium?.copyWith(
                    color: selectedListId == list.id
                        ? AppColors.primary
                        : colors.textPrimary,
                  ),
                ),
                trailing: selectedListId == list.id
                    ? const Icon(Icons.check,
                    color: AppColors.primary, size: 20)
                    : null,
                onTap: () => onSelected(list.id),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// Bottom Sheet: вибір пріоритету

class _PriorityPickerSheet extends StatelessWidget {
  const _PriorityPickerSheet({
    required this.current,
    required this.onSelected,
  });

  final TaskPriority current;
  final ValueChanged<TaskPriority> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final t = context.t;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
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
            const SizedBox(height: 16),
            Text(t.task.choosePriority, style: textTheme.titleLarge),
            const SizedBox(height: 8),
            ...TaskPriority.values.map(
                  (p) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.flag,
                    color: p == TaskPriority.none
                        ? colors.textSecondary
                        : p.color,
                    size: 22),
                title: Text(
                  p.label(t),
                  style: textTheme.titleMedium?.copyWith(
                    color: current == p ? AppColors.primary :
                                          colors.textPrimary,
                  ),
                ),
                trailing: current == p
                    ? const Icon(Icons.check,
                    color: AppColors.primary, size: 20)
                    : null,
                onTap: () => onSelected(p),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// Bottom Sheet: вибір нагадування

class _ReminderPickerSheet extends StatelessWidget {
  const _ReminderPickerSheet({
    required this.current,
    required this.onSelected,
  });

  final int? current;
  final ValueChanged<int?> onSelected;

  static const List<int?> _options = [
    null,   // без нагадування
    0,      // у момент
    10,     // за 10 хв
    30,     // за 30 хв
    60,     // за 1 год
    1440,   // за 1 день
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final t = context.t;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
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
            const SizedBox(height: 16),
            Text(t.task.chooseReminder, style: textTheme.titleLarge),
            const SizedBox(height: 8),
            ..._options.map(
                  (opt) {
                final isSelected = opt == current;
                final label = opt == null
                    ? t.task.noReminder
                    : _reminderLabel(opt, t);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    opt == null
                        ? Icons.notifications_off_outlined
                        : Icons.notifications_outlined,
                    color: isSelected ? AppColors.primary :
                                        colors.textSecondary,
                    size: 22,
                  ),
                  title: Text(
                    label,
                    style: textTheme.titleMedium?.copyWith(
                      color: isSelected ? AppColors.primary :
                                          colors.textPrimary,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check,
                      color: AppColors.primary, size: 20)
                      : null,
                  onTap: () => onSelected(opt),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
