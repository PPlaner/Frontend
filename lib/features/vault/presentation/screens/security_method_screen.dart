import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/i18n/strings.g.dart';

class SecurityMethodScreen extends StatefulWidget {
  const SecurityMethodScreen({super.key});

  @override
  State<SecurityMethodScreen> createState() => _SecurityMethodScreenState();
}

class _SecurityMethodScreenState extends State<SecurityMethodScreen> {
  String? selectedMethodId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: AppColors.primary,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                t.security_methods.title,
                style: textTheme.displayLarge?.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                t.security_methods.subtitle,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              _buildOption(
                title: t.security_methods.pin_title,
                subtitle: t.security_methods.pin_sub,
                id: 'pin',
                colors: colors,
              ),
              _buildOption(
                title: t.security_methods.pattern_title,
                subtitle: t.security_methods.pattern_sub,
                id: 'pattern',
                colors: colors,
              ),
              _buildOption(
                title: t.security_methods.word_title,
                subtitle: t.security_methods.word_sub,
                id: 'word',
                colors: colors,
              ),

              const Spacer(),

              FilledButton(
                onPressed: selectedMethodId == null
                    ? null
                    : () {
                  if (selectedMethodId == 'pin') {
                    Navigator.pushNamed(context, '/pin-setup');
                  } else if (selectedMethodId == 'pattern') {
                    Navigator.pushNamed(context, '/pattern-setup');
                  } else if (selectedMethodId == 'word') {
                    Navigator.pushNamed(context, '/association-setup');
                  }
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  t.common.next,
                  style: textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption({
    required String title,
    required String subtitle,
    required String id,
    required AppColorScheme colors,
  }) {
    final isSelected = selectedMethodId == id;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => selectedMethodId = id),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: colors.surface,                        // адаптивний
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary                    // статичний
                  : AppColors.primary.withOpacity(0.1),  // статичний
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
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
                  color: AppColors.primary,              // статичний
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,           // адаптивний
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}