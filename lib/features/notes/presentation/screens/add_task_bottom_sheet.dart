import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/notes/domain/constants.dart';
import 'package:frontend/features/notes/domain/entities/note.dart';
import 'package:frontend/features/notes/domain/entities/project.dart';
import 'package:frontend/features/notes/domain/models/note_creation_payload.dart';
import 'package:frontend/features/notes/domain/task_priority.dart';
import 'package:frontend/features/notes/presentation/helpers.dart';
import 'package:frontend/features/notes/presentation/notifiers/notes_notifier.dart';
import 'package:frontend/features/notes/presentation/notifiers/projects_notifier.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:frontend/features/notes/presentation/widgets/meta_icon_button.dart';
import 'package:frontend/features/notes/presentation/widgets/pickers/priority_picker_sheet.dart';
import 'package:frontend/features/notes/presentation/widgets/pickers/project_picker_sheet.dart';
import 'package:frontend/features/notes/presentation/widgets/pickers/reminder_picker_sheet.dart';
import 'package:frontend/i18n/strings.g.dart';

class AddTaskBottomSheet extends ConsumerStatefulWidget {
  const AddTaskBottomSheet({
    super.key,
    this.initialData,
  });

  final Note? initialData;

  bool get isEditing => initialData != null;

  @override
  ConsumerState<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends ConsumerState<AddTaskBottomSheet> {
  List<Project>? _projects;

  late final TextEditingController _titleController;
  late final QuillController _quillController;
  final FocusNode _titleFocus = FocusNode();

  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  String? _projectId;
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
          {'insert': '${init.subtitle}\n'},
        ]);
      }
    }

    _dueDate = init?.dueDate;
    _dueTime = init?.dueTime;
    _projectId = init?.projectId;
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

    if (widget.isEditing) {
      final updated = widget.initialData!.copyWith(
        title: title,
        content: _quillController.document,
        projectId: _projectId,
        dueDate: _dueDate,
        dueTime: _dueTime,
        priority: _priority,
        reminderMinutesBefore: _reminderMinutesBefore,
      );

      unawaited(ref.read(notesProvider.notifier).saveNote(updated));
    } else {
      final selectedProjectId = ref.read(selectedProjectIdProvider);

      if (selectedProjectId != todayProjectId &&
          selectedProjectId != inboxProjectId &&
          selectedProjectId != allProjectsId) {
        _projectId = selectedProjectId;
      }

      final payload = NoteCreationPayload(
        title: title,
        content: _quillController.document,
        projectId: _projectId,
        dueDate: _dueDate,
        dueTime: _dueTime,
        priority: _priority,
        reminderMinutesBefore: _reminderMinutesBefore,
      );

      unawaited(ref.read(notesProvider.notifier).createNote(payload));
    }

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
    if (_projects == null) return;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ProjectPickerSheet(
        projects: _projects!,
        selectedProjectId: _projectId,
        onSelected: (id) {
          setState(() => _projectId = id);
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
      builder: (_) => PriorityPickerSheet(
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
      builder: (_) => ReminderPickerSheet(
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
    if (_projectId == null || _projects == null) return null;
    return _projects!.where((p) => p.id == _projectId).firstOrNull?.title;
  }

  // Build

  @override
  Widget build(BuildContext context) {
    _projects = ref.read(projectsProvider).value;

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
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
                        final fontFamily = Theme.of(
                          context,
                        ).textTheme.bodyLarge?.fontFamily;
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
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 12,
                      children: [
                        // Календар
                        MetaIconButton(
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
                        MetaIconButton(
                          icon: Icons.folder_outlined,
                          label: _listName(),
                          isActive: _projectId != null,
                          onTap: _pickList,
                          onClear: _projectId != null
                              ? () => setState(() => _projectId = null)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        // Прапорець — пріоритет
                        MetaIconButton(
                          icon: Icons.flag_outlined,
                          label: _priority != TaskPriority.none
                              ? _priority.label(t)
                              : null,
                          isActive: _priority != TaskPriority.none,
                          activeColor: _priority.color,
                          onTap: _pickPriority,
                          onClear: _priority != TaskPriority.none
                              ? () => setState(
                                  () => _priority = TaskPriority.none,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        // Нагадування
                        MetaIconButton(
                          icon: Icons.notifications_none_outlined,
                          label: _reminderMinutesBefore != null
                              ? reminderLabel(_reminderMinutesBefore!, t)
                              : null,
                          isActive: _reminderMinutesBefore != null,
                          onTap: _pickReminder,
                          onClear: _reminderMinutesBefore != null
                              ? () => setState(
                                  () => _reminderMinutesBefore = null,
                                )
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
