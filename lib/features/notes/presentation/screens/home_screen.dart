import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/features/notes/domain/entities/task_list_model.dart';
import 'package:frontend/features/notes/presentation/screens/add_task_bottom_sheet.dart';
import 'package:frontend/i18n/strings.g.dart';

// Модель завдання
// Перенести в domain/entities/ коли буде підключено Riverpod

class TaskItem {
  TaskItem({
    required this.id,
    required this.title,
    required this.dateLabel,
    required this.listId,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String dateLabel;
  final String listId;
  bool isCompleted;
}

// HomeScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // Замінити на Riverpod провайдер
  final List<TaskItem> _tasks = [];

  // "inbox" — вбудований захищений список, назва береться з локалізації в build
  static const String _inboxListId = 'inbox';
  final List<TaskList> _lists = [
    TaskList(
      id: 'inbox',
      name: 'inbox',
      emoji: '📥',
      color: AppColors.primary,
    ),
  ];

  static const String _todayListId = '__today__';

  String _selectedListId = _todayListId;

  int _currentNavIndex = 0;
  bool _completedExpanded = true;
  bool _isBottomSheetOpen = false;

  // Анімація drawer
  late AnimationController _drawerController;
  late Animation<double> _drawerAnimation;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _drawerAnimation = CurvedAnimation(
      parent: _drawerController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  Future<void> _openDrawer() async {
    setState(() => _isDrawerOpen = true);
    await _drawerController.forward();
  }

  Future<void> _closeDrawer() async {
    await _drawerController.reverse().then((_) {
      setState(() => _isDrawerOpen = false);
    });
  }

  // Фільтрація завдань по обраному списку
  List<TaskItem> get _filteredTasks {
    if (_selectedListId == _todayListId) return _tasks;
    return _tasks.where((t) => t.listId == _selectedListId).toList();
  }

  List<TaskItem> get _activeTasks =>
      _filteredTasks.where((t) => !t.isCompleted).toList();

  List<TaskItem> get _completedTasks =>
      _filteredTasks.where((t) => t.isCompleted).toList();

  bool get _hasTasks => _filteredTasks.isNotEmpty;

  String get _currentListTitle {
    if (_selectedListId == _todayListId) return context.t.home.today;
    if (_selectedListId == _inboxListId) return context.t.home.inbox;
    return _lists.firstWhere(
          (l) => l.id == _selectedListId,
      orElse: () => TaskList(id: '',
                            name: context.t.home.today,
                            emoji: '📋',
                            color: AppColors.primary),
    ).name;
  }

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
        dateLabel: context.t.home.today,
        listId: _selectedListId == _todayListId ? 'inbox' : _selectedListId,
      ));
    });
  }

  Future<void> _openAddTask() async {
    setState(() => _isBottomSheetOpen = true);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (_) => AddTaskBottomSheet(onTaskAdded: _addTask),
    ).whenComplete(() {
      setState(() => _isBottomSheetOpen = false);
    });
  }

  Future<void> _selectList(String listId) async {
    setState(() => _selectedListId = listId);
    await _closeDrawer();
  }

  Future<void> _openCreateList() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateListSheet(
        onSaved: (list) {
          setState(() => _lists.add(list));
        },
      ),
    );
  }

  Future<void> _openEditList(TaskList list) async {
    final isInbox = list.id == _inboxListId;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateListSheet(
        initialList: list,
        colorOnly: isInbox,
        onSaved: (updated) {
          setState(() {
            final idx = _lists.indexWhere((l) => l.id == updated.id);
            if (idx != -1) _lists[idx] = updated;
          });
        },
      ),
    );
  }

  Future<void> _deleteList(TaskList list) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final t = ctx.t;
        final textTheme = Theme.of(ctx).textTheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          actionsAlignment: MainAxisAlignment.center,
          title: Text(
            t.home.deleteListTitle,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge,
          ),
          content: Text(
            t.home.deleteListMessage,
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
    if (confirmed == true) {
      setState(() {
        _tasks.removeWhere((t) => t.listId == list.id);
        _lists.removeWhere((l) => l.id == list.id);
        if (_selectedListId == list.id) _selectedListId = _todayListId;
      });
    }
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
                  onPressed: _openDrawer,
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
                    key: ValueKey('list-$_selectedListId'),
                    activeTasks: _activeTasks,
                    completedTasks: _completedTasks,
                    completedExpanded: _completedExpanded,
                    onToggleTask: _toggleTask,
                    onDeleteTask: _deleteTask,
                    onToggleCompleted: () => setState(
                          () => _completedExpanded = !_completedExpanded,
                    ),
                    title: _currentListTitle,
                  )
                      : _EmptyStateView(
                          key: const ValueKey('empty'),
                          title: _currentListTitle,
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            right: 16,
            bottom: 16,
            child: AnimatedScale(
              scale: _isDrawerOpen ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                opacity: _isDrawerOpen ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 180),
                child: FloatingActionButton(
                  onPressed: _isDrawerOpen ? null : _openAddTask,
                  backgroundColor: AppColors.primary,
                  foregroundColor: colors.surface,
                  elevation: 4,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add, size: 28),
                ),
              ),
            ),
          ),

          if (_isBottomSheetOpen)
            Positioned.fill(
              child: IgnorePointer(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),

          // Drawer overlay — затемнення фону
          if (_isDrawerOpen)
            AnimatedBuilder(
              animation: _drawerAnimation,
              builder: (_, _) => GestureDetector(
                onTap: _closeDrawer,
                child: Container(
                  color: Colors.black.withValues(
                      alpha: 0.35 * _drawerAnimation.value),
                ),
              ),
            ),

          // Drawer panel
          if (_isDrawerOpen)
            AnimatedBuilder(
              animation: _drawerAnimation,
              builder: (_, child) {
                final screenWidth = MediaQuery.of(context).size.width;
                final drawerWidth = screenWidth * 0.82;
                return Positioned(
                  left: -drawerWidth * (1 - _drawerAnimation.value),
                  top: 0,
                  bottom: 0,
                  width: drawerWidth,
                  child: child!,
                );
              },
              child: _ListsDrawer(
                lists: _lists,
                selectedListId: _selectedListId,
                todayListId: _todayListId,
                inboxListId: _inboxListId,
                onSelectList: _selectList,
                onCreateList: _openCreateList,
                onEditList: _openEditList,
                onDeleteList: _deleteList,
              ),
            ),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
      ),
    );
  }
}

// Drawer з переліком списків

class _ListsDrawer extends StatelessWidget {
  const _ListsDrawer({
    required this.lists,
    required this.selectedListId,
    required this.todayListId,
    required this.inboxListId,
    required this.onSelectList,
    required this.onCreateList,
    required this.onEditList,
    required this.onDeleteList,
  });

  final List<TaskList> lists;
  final String selectedListId;
  final String todayListId;
  final String inboxListId;
  final ValueChanged<String> onSelectList;
  final VoidCallback onCreateList;
  final ValueChanged<TaskList> onEditList;
  final ValueChanged<TaskList> onDeleteList;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final t = context.t;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues( alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                t.home.myLists,
                style: textTheme.titleLarge,
              ),
            ),

            const SizedBox(height: 8),

            // "Сьогодні" — фіксований елемент (без редагування/видалення)
            _DrawerListItem(
              emoji: '📅',
              name: t.home.today,
              count: null,
              isSelected: selectedListId == todayListId,
              color: AppColors.primary,
              onTap: () => onSelectList(todayListId),
              onEdit: null,
              onDelete: null,
            ),

            // "Вхідні" — закріплений, лише зміна кольору
            Builder(builder: (context) {
              final inbox = lists.firstWhere(
                    (l) => l.id == inboxListId,
                orElse: () => TaskList(
                  id: inboxListId,
                  name: t.home.inbox,
                  emoji: '📥',
                  color: AppColors.primary,
                ),
              );
              return _DrawerListItem(
                emoji: inbox.emoji,
                name: t.home.inbox,
                count: inbox.taskCount > 0 ? inbox.taskCount : null,
                isSelected: selectedListId == inboxListId,
                color: inbox.color,
                onTap: () => onSelectList(inboxListId),
                onEdit: () => onEditList(inbox),
                onDelete: null,
              );
            }),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Divider(
                height: 1,
                color: colors.divider,
              ),
            ),

            // Користувацькі списки (всі крім inbox)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: lists.where((l) => l.id != inboxListId).length,
                itemBuilder: (_, i) {
                  final userLists = lists.where((l) =>
                    l.id != inboxListId).toList();
                  final list = userLists[i];
                  return _DrawerListItem(
                    emoji: list.emoji,
                    name: list.name,
                    count: list.taskCount > 0 ? list.taskCount : null,
                    isSelected: selectedListId == list.id,
                    color: list.color,
                    onTap: () => onSelectList(list.id),
                    onEdit: () => onEditList(list),
                    onDelete: () => onDeleteList(list),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Divider(height: 1, color: colors.divider),
            ),

            // Кнопка "Додати список"
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
              child: TextButton.icon(
                onPressed: onCreateList,
                icon: const Icon(Icons.add_box_outlined, size: 20),
                label: Text(t.home.addList),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8,
                                                      vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerListItem extends StatelessWidget {
  const _DrawerListItem({
    required this.emoji,
    required this.name,
    required this.count,
    required this.isSelected,
    required this.color,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final String emoji;
  final String name;
  final int? count;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  Future<void> _showContextMenu(BuildContext context) async {
    if (onEdit == null && onDelete == null) return;
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
        if (onEdit != null)
          PopupMenuItem<String>(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit_outlined,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface),
                const SizedBox(width: 12),
                Text(t.home.editList,
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        if (onDelete != null)
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                const Icon(Icons.delete_outline,
                    size: 20, color: AppColors.error),
                const SizedBox(width: 12),
                Text(
                  t.home.deleteList,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.error),
                ),
              ],
            ),
          ),
      ],
    ).then((value) {
      if (value == 'edit') onEdit?.call();
      if (value == 'delete') onDelete?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: (onEdit != null || onDelete != null)
            ? () => _showContextMenu(context)
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ?
                    color.withValues(alpha: 0.12) :
                    Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: textTheme.titleMedium?.copyWith(
                    color: isSelected ? color : colors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: 8),
                Text(
                  '$count',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
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

// Bottom Sheet: створення нового списку

class _CreateListSheet extends StatefulWidget {
  const _CreateListSheet({
    required this.onSaved,
    this.initialList,
    this.colorOnly = false,
  });

  /// Якщо передано — режим редагування, інакше — створення.
  final TaskList? initialList;

  /// Якщо true — показувати лише вибір кольору (для "Вхідні").
  final bool colorOnly;
  final ValueChanged<TaskList> onSaved;

  @override
  State<_CreateListSheet> createState() => _CreateListSheetState();
}

class _CreateListSheetState extends State<_CreateListSheet> {
  late final TextEditingController _nameController;
  final _nameFocus = FocusNode();

  late Color _selectedColor;
  late String _selectedEmoji;

  bool get _isEditing => widget.initialList != null;
  bool get _colorOnly => widget.colorOnly;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialList;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _selectedColor = initial?.color ?? AppColors.primary;
    _selectedEmoji = initial?.emoji ?? '📋';
    if (!_colorOnly) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          _nameFocus.requestFocus());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_colorOnly) {
      final saved = widget.initialList!.copyWith(color: _selectedColor);
      widget.onSaved(saved);
      Navigator.of(context).pop();
      return;
    }

    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final saved = _isEditing
        ? widget.initialList!.copyWith(
      name: name,
      emoji: _selectedEmoji,
      color: _selectedColor,
    )
        : TaskList(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      emoji: _selectedEmoji,
      color: _selectedColor,
    );

    widget.onSaved(saved);
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
              // Drag handle
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

              // Заголовок
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.cancel_outlined,
                        color: colors.textSecondary, size: 24),
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
                    child: const Icon(Icons.check,
                        color: AppColors.primary, size: 24),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Поле назви — приховане в colorOnly режимі
              if (!_colorOnly)
                Container(
                  height: 51,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16,
                                                      vertical: 15),
                  child: Row(
                    children: [
                      Text(_selectedEmoji,
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          focusNode: _nameFocus,
                          style: textTheme.bodyLarge,
                          decoration: InputDecoration(
                            hintText: t.home.listName,
                            hintStyle: textTheme.bodyLarge?.copyWith(
                                color: colors.textSecondary),
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

              // Вибір кольору
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
                          onTap: () => setState(() =>
                            _selectedColor = AppColors.primary),
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
                                width: _selectedColor ==
                                    AppColors.primary ? 1.5 : 1.0,
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

                        // Існуючі кольори для списків завдань
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

              // Вибір емодзі — прихований для "Вхідні"
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
                                    ? Border.all(color: _selectedColor,
                                                  width: 1.5)
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(emoji,
                                  style: const TextStyle(fontSize: 20)),
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

// Порожній стан (Головна 1)

class _EmptyStateView extends StatelessWidget {
  const _EmptyStateView({
    required this.title, super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Text(title, style: textTheme.displayLarge),
        ),
        Expanded(
          child: Center(
            child: Opacity(
              opacity: 0.45,
              child: SizedBox(
                width: 168,
                height: 159,
                child: Image.asset(
                  AppAssets.logo,
                  height: 159,
                  width: 168,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Список завдань (Головна 2)

class _TaskListView extends StatelessWidget {
  const _TaskListView({
    required this.activeTasks,
    required this.completedTasks,
    required this.completedExpanded,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onToggleCompleted,
    required this.title,
    super.key,
  });

  final List<TaskItem> activeTasks;
  final List<TaskItem> completedTasks;
  final bool completedExpanded;
  final ValueChanged<TaskItem> onToggleTask;
  final ValueChanged<TaskItem> onDeleteTask;
  final VoidCallback onToggleCompleted;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      children: [
        Text(title, style: textTheme.displayLarge),
        const SizedBox(height: 16),

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

// Активне завдання зі свайпом

class _SwipableTaskCard extends StatelessWidget {
  const _SwipableTaskCard({
    required this.task,
    required this.onToggle,
    required this.onDelete,
    super.key,
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
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline,
            color: AppColors.error, size: 24),
      ),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
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

// Завершене завдання

class _SwipableCompletedTile extends StatelessWidget {
  const _SwipableCompletedTile({
    required this.task,
    required this.onToggle,
    required this.onDelete,
    super.key,
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
        child: const Icon(Icons.delete_outline,
            color: AppColors.error, size: 24),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Row(
          children: [
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
        content: Text(t.home.deleteTaskMessage, textAlign: TextAlign.center),
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
                        color: colors.textSecondary),
                  ),
                  const Spacer(),
                  Text('$count', style: textTheme.bodySmall),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: isExpanded ? 0 : -0.5,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down,
                        color: colors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Column(children: children),
            secondChild: const SizedBox.shrink(),
            crossFadeState:
            isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
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
