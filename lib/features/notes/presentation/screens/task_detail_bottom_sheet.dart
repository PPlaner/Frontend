import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/features/notes/domain/entities/note.dart';
import 'package:frontend/features/notes/domain/task_priority.dart';
import 'package:frontend/features/notes/presentation/helpers.dart';
import 'package:frontend/features/notes/presentation/notifiers/notes_notifier.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:frontend/features/notes/presentation/screens/add_task_bottom_sheet.dart';
import 'package:frontend/features/notes/presentation/widgets/notes/editor/note_editor_sheet.dart';
import 'package:frontend/i18n/strings.g.dart';

class TaskDetailBottomSheet extends ConsumerStatefulWidget {
  const TaskDetailBottomSheet({
    required this.note,
    super.key,
  });

  final Note note;

  @override
  ConsumerState<TaskDetailBottomSheet> createState() =>
      _TaskDetailBottomSheetState();
}

class _TaskDetailBottomSheetState extends ConsumerState<TaskDetailBottomSheet> {
  late Note _task;
  QuillController? _readOnlyController;

  @override
  void initState() {
    super.initState();

    _task = widget.note;

    _initQuillController();
  }

  @override
  void dispose() {
    _readOnlyController?.dispose();

    super.dispose();
  }

  void _initQuillController() {
    final oldController = _readOnlyController;

    if (_task.subtitle.isEmpty) {
      _readOnlyController = null;
      return;
    }

    _readOnlyController = QuillController(
      document: Document.fromDelta(_task.content.toDelta()),
      selection: const TextSelection.collapsed(offset: 0),
    );

    oldController?.dispose();
  }

  Future<void> _openEditSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.15),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: NoteEditorSheet(
          existingNote: _task,
        ),
      ),
    );

    // if (!mounted) return;
    //
    // Navigator.of(context).pop();
  }

  Future<void> _confirmAndDelete() async {
    final confirmed = await confirmDeletion(
      context,
      context.t.home.deleteTask,
      context.t.home.deleteTaskMessage,
    );

    if (confirmed && mounted) {
      Navigator.of(context).pop();

      unawaited(ref.read(notesProvider.notifier).deleteNote(_task));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(notesProvider, (prev, next) {
      final updatedNote = next.value
          ?.where((n) => n.id == _task.id)
          .firstOrNull;

      if (updatedNote != null && updatedNote != _task) {
        final subtitleChanged = updatedNote.subtitle != _task.subtitle;

        setState(() {
          _task = updatedNote;
        });

        if (subtitleChanged) {
          _initQuillController();
        }
      }
    });

    final listName = ref.watch(selectedProjectTitleProvider);

    final t = context.t;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                  color: context.theme.dividerColor,
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
                  onTap: () =>
                      ref.read(notesProvider.notifier).toggleNote(widget.note),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _task.isCompleted
                          ? context.colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: context.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    child: _task.isCompleted
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: context.colorScheme.surface,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 12),

                // Назва завдання
                Expanded(
                  child: Text(
                    _task.title,
                    style: context.textTheme.titleLarge?.copyWith(
                      decoration: _task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: _task.isCompleted
                          ? context.theme.hintColor
                          : context.colorScheme.onSurface,
                    ),
                  ),
                ),

                // Кнопка редагувати
                IconButton(
                  onPressed: _openEditSheet,
                  icon: Icon(
                    Icons.edit_outlined,
                    color: context.colorScheme.primary,
                    size: 22,
                  ),
                  tooltip: t.home.editTask,
                  visualDensity: VisualDensity.compact,
                ),

                // Кнопка видалити
                IconButton(
                  onPressed: _confirmAndDelete,
                  icon: Icon(
                    Icons.delete_outline,
                    color: context.colorScheme.error,
                    size: 22,
                  ),
                  tooltip: t.home.deleteTask,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: context.theme.dividerColor, height: 1),
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
                          context.textTheme.bodyLarge!.copyWith(
                            color: context.colorScheme.surface,
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
                  formatDateTime(_task.dueDate!, _task.dueTime, t),
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
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
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
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
                  style: context.textTheme.bodyLarge?.copyWith(
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
                  reminderLabel(_task.reminderMinutesBefore!, t),
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor ?? context.theme.hintColor),
        const SizedBox(width: 12),
        Expanded(child: child),
      ],
    );
  }
}
