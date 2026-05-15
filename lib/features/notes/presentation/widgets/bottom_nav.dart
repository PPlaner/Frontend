import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/notes/domain/constants.dart';
import 'package:frontend/features/notes/presentation/navigation/notes_routes.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:frontend/i18n/strings.g.dart';
import 'package:go_router/go_router.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/notes/calendar')) return 1;
    // if (location.startsWith('/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final currentIndex = _calculateSelectedIndex(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.bottomNav,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;

          switch (index) {
            case 0:
              if (ref.read(selectedProjectIdProvider) == allProjectsId) {
                ref
                    .read(selectedProjectIdProvider.notifier)
                    .set(todayProjectId);
              }
              const NotesRoute().go(context);
            case 1:
              ref.read(selectedProjectIdProvider.notifier).set(allProjectsId);
              const NotesCalendarRoute().go(context);
            case 2:
              // const ProfileRoute().go(context);
              break;
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: colors.textPrimary,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.check_box_outlined),
            label: context.t.bottomNav.tasks,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            label: context.t.bottomNav.calendar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: context.t.bottomNav.profile,
          ),
        ],
      ),
    );
  }
}
