import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/notes/domain/entities/project.dart';
import 'package:frontend/features/notes/domain/entities/task_list_model.dart';
import 'package:frontend/features/notes/domain/models/project_creation_payload.dart';
import 'package:frontend/features/notes/presentation/notifiers/projects_notifier.dart';
import 'package:frontend/i18n/strings.g.dart';

class CreateProjectSheet extends ConsumerStatefulWidget {
  const CreateProjectSheet({
    this.initialProject,
    this.colorOnly = false,
    super.key,
  });

  final Project? initialProject;
  final bool colorOnly;

  @override
  ConsumerState<CreateProjectSheet> createState() => _CreateListSheetState();
}

class _CreateListSheetState extends ConsumerState<CreateProjectSheet> {
  late final TextEditingController _nameController;
  final _nameFocus = FocusNode();

  late Color _selectedColor;
  late String _selectedEmoji;

  bool get _isEditing => widget.initialProject != null;
  bool get _colorOnly => widget.colorOnly;

  @override
  void initState() {
    super.initState();

    final initial = widget.initialProject;

    _nameController = TextEditingController(text: initial?.title ?? '');

    _selectedColor = initial?.color ?? AppColors.primary;
    _selectedEmoji = initial?.emoji ?? '📋';

    if (!_colorOnly) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _nameFocus.requestFocus(),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();

    super.dispose();
  }

  void _confirm() {
    final notifier = ref.read(projectsProvider.notifier);

    if (_colorOnly) {
      final project = widget.initialProject!.copyWith(color: _selectedColor);

      unawaited(notifier.saveProject(project));
    } else {
      final name = _nameController.text.trim();
      if (name.isEmpty) return;

      if (_isEditing) {
        final project = widget.initialProject!.copyWith(
          title: name,
          emoji: _selectedEmoji,
          color: _selectedColor,
        );

        unawaited(notifier.saveProject(project));
      } else {
        final payload = ProjectCreationPayload(
          title: name,
          emoji: _selectedEmoji,
          color: _selectedColor,
        );

        unawaited(notifier.createProject(payload));
      }
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final t = context.t;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(16, 0, 16, keyboardHeight + 16),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.cancel_outlined,
                      color: colors.textSecondary,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _colorOnly
                          ? t.home.listColor
                          : (_isEditing ? t.home.editList : t.home.addList),
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium,
                    ),
                  ),
                  GestureDetector(
                    onTap: _confirm,
                    child: const Icon(
                      Icons.check,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              if (!_colorOnly)
                Container(
                  height: 51,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  child: Row(
                    children: [
                      Text(
                        _selectedEmoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          focusNode: _nameFocus,
                          style: textTheme.bodyLarge,
                          decoration: InputDecoration(
                            hintText: t.home.listName,
                            hintStyle: textTheme.bodyLarge?.copyWith(
                              color: colors.textSecondary,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            filled: true,
                            fillColor: colors.surface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (!_colorOnly) const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.home.listColor, style: textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        GestureDetector(
                          onTap: () => setState(
                            () => _selectedColor = AppColors.primary,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: colors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedColor == AppColors.primary
                                    ? colors.textPrimary
                                    : colors.divider,
                                width: _selectedColor == AppColors.primary
                                    ? 1.5
                                    : 1.0,
                              ),
                            ),
                            child: Icon(
                              Icons.format_color_reset_outlined,
                              size: 18,
                              color: _selectedColor == AppColors.primary
                                  ? colors.textPrimary
                                  : colors.textSecondary,
                            ),
                          ),
                        ),
                        ...kListColors.map((color) {
                          final isSelected = _selectedColor == color;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedColor = color),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: colors.textPrimary,
                                        width: 1.5,
                                      )
                                    : null,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              if (!_colorOnly)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.home.listIcon, style: textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: kListEmojis.map((emoji) {
                          final isSelected = _selectedEmoji == emoji;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedEmoji = emoji),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _selectedColor.withValues(alpha: 0.15)
                                    : colors.background,
                                borderRadius: BorderRadius.circular(10),
                                border: isSelected
                                    ? Border.all(
                                        color: _selectedColor,
                                        width: 1.5,
                                      )
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                emoji,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
