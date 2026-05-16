import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/features/notes/domain/constants.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:frontend/features/notes/presentation/widgets/projects/create_project_sheet.dart';
import 'package:frontend/i18n/strings.g.dart';

class DrawerVirtualProjectItem extends ConsumerWidget {
  const DrawerVirtualProjectItem({
    required this.id,
    required this.count,
    required this.title,
    required this.emoji,
    required this.color,
    super.key,
  });

  final String id;
  final int? count;
  final String title;
  final String emoji;
  final Color color;

  Future<void> _openEditList(BuildContext context) async {
    final isInbox = id == inboxProjectId;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateProjectSheet(colorOnly: isInbox),
    );
  }

  Future<void> _showContextMenu(BuildContext context, WidgetRef ref) async {
    final t = context.t;
    final renderBox = context.findRenderObject()! as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final offset = renderBox.localToGlobal(
      Offset(renderBox.size.width - 8, renderBox.size.height / 2),
      ancestor: overlay,
    );

    final position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy - 20,
      overlay.size.width - offset.dx,
      overlay.size.height - offset.dy,
    );

    await showMenu<String>(
      context: context,
      position: position,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: [
        if (id == inboxProjectId)
          PopupMenuItem<String>(
            value: 'edit',
            child: Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: context.colorScheme.onSurface,
                ),
                const SizedBox(width: 12),
                Text(
                  t.home.editList,
                  style: context.textTheme.titleMedium,
                ),
              ],
            ),
          ),
      ],
    ).then((value) {
      if (!context.mounted) return;

      unawaited(_openEditList(context));
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(selectedProjectIdProvider) == id;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => ref.read(selectedProjectIdProvider.notifier).set(id),
        onLongPress: () => _showContextMenu(context, ref),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: isSelected ? color : context.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: 8),
                Text(
                  '$count',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.theme.hintColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
