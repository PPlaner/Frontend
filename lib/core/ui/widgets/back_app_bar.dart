import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/navigation_helper.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        color: AppColors.primary,
        onPressed: context.safePop,
      ),
    );
  }
}
