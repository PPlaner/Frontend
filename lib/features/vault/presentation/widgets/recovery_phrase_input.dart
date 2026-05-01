import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/i18n/strings.g.dart';

class RecoveryPhraseInput extends StatefulWidget {
  const RecoveryPhraseInput({
    required this.onPhraseCompleted,
    required this.onPhraseIncomplete,
    super.key,
  });

  final ValueChanged<List<String>> onPhraseCompleted;
  final VoidCallback onPhraseIncomplete;

  @override
  State<RecoveryPhraseInput> createState() => _RecoveryPhraseInputState();
}

class _RecoveryPhraseInputState extends State<RecoveryPhraseInput> {
  final List<TextEditingController> _controllers = List.generate(
    12,
    (_) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    for (final c in _controllers) {
      c.addListener(_validateInputs);
    }
  }

  void _validateInputs() {
    final allFilled = _controllers.every((c) => c.text.trim().isNotEmpty);
    if (allFilled) {
      final words = _controllers.map((c) => c.text.trim()).toList();
      widget.onPhraseCompleted(words);
    } else {
      widget.onPhraseIncomplete();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) => _buildInputCard(
        context,
        index + 1,
        _controllers[index],
      ),
    );
  }

  Widget _buildInputCard(
    BuildContext context,
    int number,
    TextEditingController controller,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3), // статичний
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            left: 6,
            child: Text(
              '$number',
              style: textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: AppColors.primary.withValues(alpha: 0.7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Center(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(fontSize: 12),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                filled: false,
                hintText: context.t.seed.word_hint,
                hintStyle: TextStyle(
                  color: colors.textSecondary, // адаптивний
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
