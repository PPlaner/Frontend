import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class RecoveryPhraseDisplay extends StatefulWidget {
  const RecoveryPhraseDisplay({
    required this.phrase,
    super.key,
  });

  final List<String> phrase;

  @override
  State<RecoveryPhraseDisplay> createState() => _RecoveryPhraseDisplayState();
}

class _RecoveryPhraseDisplayState extends State<RecoveryPhraseDisplay> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) => _buildWordCard(
        context,
        index + 1,
        widget.phrase[index],
      ),
    );
  }

  Widget _buildWordCard(
    BuildContext context,
    int number,
    String word,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface, // адаптивний
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5), // статичний
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                color: AppColors.primary.withValues(alpha: 0.7), // статичний
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                word,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
