import 'package:flutter/material.dart';

/// Модель списку завдань (папки/проєкти).
/// Використовується як на HomeScreen (вибір активного списку),
/// так і на CalendarScreen (фільтр).
///
/// Зробити: перенести в domain/entities/ і підключити Riverpod провайдер.
class TaskList {
  TaskList({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    this.taskCount = 0,
  });

  final String id;
  String name;
  String emoji;
  Color color;
  int taskCount;

  TaskList copyWith({
    String? name,
    String? emoji,
    Color? color,
    int? taskCount,
  }) =>
      TaskList(
        id: id,
        name: name ?? this.name,
        emoji: emoji ?? this.emoji,
        color: color ?? this.color,
        taskCount: taskCount ?? this.taskCount,
      );
}

/// Статичні дефолтні кольори для вибору кольору списку
const List<Color> kListColors = [
  Color(0xFFFF3B30), // red
  Color(0xFFFF9500), // orange
  Color(0xFFFFCC00), // yellow
  Color(0xFF34C759), // green
  Color(0xFF007AFF), // blue
  Color(0xFF5856D6), // purple
  Color(0xFFAF52DE), // violet
  Color(0xFFFF2D55), // pink
];

/// Дефолтні емодзі для вибору іконки списку
const List<String> kListEmojis = [
  '📋', '⭐', '🔥', '💡', '📚', '💼', '🏃', '🎯',
  '🌱', '🎨', '🛒', '✈️', '🏠', '💪', '🎵', '🍀',
];
