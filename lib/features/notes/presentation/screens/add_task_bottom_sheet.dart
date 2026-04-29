import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:frontend/i18n/strings.g.dart';

/// Bottom Sheet для додавання нового завдання (Головна 6).
///
/// Використання:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   barrierColor: Colors.transparent,
///   builder: (_) => AddTaskBottomSheet(
///     onTaskAdded: (title, subtitle) { ... },
///   ),
/// );
/// ```
class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({
    super.key,
    required this.onTaskAdded,
  });

  final void Function(String title, String subtitle) onTaskAdded;

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final QuillController _quillController = QuillController.basic();
  final FocusNode _titleFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleFocus.requestFocus();
    });
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

    final details = _quillController.document.toPlainText().trim();
    widget.onTaskAdded(title, details);
    Navigator.of(context).pop();
  }

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

            // Рядок: ✕ | Нове завдання | ✓
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
                    t.home.newTask,
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

            // Поле вводу назви завдання "Що потрібно зробити?"
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

            // Поле "Додати деталі..." + іконки метаданих
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
                        final fontFamily =
                            Theme.of(context).textTheme.bodyLarge?.fontFamily;
                        return QuillEditor.basic(
                          controller: _quillController,
                          config: QuillEditorConfig(
                            placeholder: t.home.addDetails,
                            padding: EdgeInsets.zero,
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

                  // Іконки метаданих
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _MetaIconButton(
                        icon: Icons.calendar_today_outlined,
                        onTap: () {
                          // вибір дати
                        },
                      ),
                      const SizedBox(width: 16),
                      _MetaIconButton(
                        icon: Icons.folder_outlined,
                        onTap: () {
                          // вибір папки
                        },
                      ),
                      const SizedBox(width: 16),
                      _MetaIconButton(
                        icon: Icons.flag_outlined,
                        onTap: () {
                          // пріоритет
                        },
                      ),
                      const SizedBox(width: 16),
                      _MetaIconButton(
                        icon: Icons.notifications_none_outlined,
                        onTap: () {
                          // нагадування
                        },
                      ),
                    ],
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
                  showBoldButton: true,
                  showItalicButton: true,
                  showUnderLineButton: true,
                  showListBullets: true,
                  showListNumbers: true,
                  showStrikeThrough: false,
                  showColorButton: false,
                  showBackgroundColorButton: false,
                  showClearFormat: false,
                  showAlignmentButtons: false,
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

// Допоміжний віджет іконки метаданих

class _MetaIconButton extends StatelessWidget {
  const _MetaIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 20, color: AppColors.primary),
    );
  }
}