import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/i18n/strings.g.dart';

class RecoveryVerifyForm extends StatefulWidget {
  const RecoveryVerifyForm({
    required this.originalPhrase,
    required this.onSuccess,
    super.key,
  });

  final List<String> originalPhrase;
  final VoidCallback onSuccess;

  @override
  State<RecoveryVerifyForm> createState() => _RecoveryVerifyFormState();
}

class _RecoveryVerifyFormState extends State<RecoveryVerifyForm>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    3,
    (_) => TextEditingController(),
  );

  late final List<int> _randomIndices;
  late final AnimationController _shakeController;

  bool _isError = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    for (final controller in _controllers) {
      controller.addListener(_validateInputs);
    }

    final list = List<int>.generate(12, (i) => i)..shuffle();
    _randomIndices = list.take(3).toList()..sort();
  }

  @override
  void dispose() {
    _shakeController.dispose();

    for (final c in _controllers) {
      c.dispose();
    }

    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _isButtonEnabled = _controllers.every((c) => c.text.trim().isNotEmpty);
      if (_isError) _isError = false;
    });
  }

  Future<void> _verifyAndSubmit() async {
    var allCorrect = true;
    for (var i = 0; i < 3; i++) {
      final userInput = _controllers[i].text.trim().toLowerCase();
      final correctWord = widget.originalPhrase[_randomIndices[i]]
          .trim()
          .toLowerCase();

      if (userInput != correctWord) {
        allCorrect = false;
        break;
      }
    }

    if (allCorrect) {
      widget.onSuccess();
    } else {
      setState(() => _isError = true);
      await _shakeController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        if (_isError) ...[
          Text(
            t.seed.verify_error,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),
        ],

        AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            final offset = sin(_shakeController.value * pi * 4) * 8;

            return Transform.translate(
              offset: Offset(_isError ? offset : 0, 0),
              child: child,
            );
          },
          child: Column(
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildNumberedField(
                  context,
                  _randomIndices[index] + 1,
                  _controllers[index],
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 24),

        FilledButton(
          onPressed: _isButtonEnabled ? _verifyAndSubmit : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            backgroundColor: AppColors.primary,
          ),
          child: Text(
            t.common.register,
            style: textTheme.labelLarge?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberedField(
    BuildContext context,
    int number,
    TextEditingController controller,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Row(
      children: [
        SizedBox(
          width: 35,
          child: Text(
            '$number.',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isError
                    ? AppColors.error.withValues(alpha: 0.5)
                    : AppColors.primary.withValues(alpha: 0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  filled: false,
                  hintText: t.seed.verify_input_hint,
                  hintStyle: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
