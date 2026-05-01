import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class UnlockMethod extends StatelessWidget {
  const UnlockMethod({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: colors.surface, // адаптивний
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.1), // статичний
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.primary, // статичний
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary, // адаптивний
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
