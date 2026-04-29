import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/i18n/strings.g.dart';

class VerifyPhraseScreen extends StatefulWidget {
  const VerifyPhraseScreen({super.key});

  @override
  State<VerifyPhraseScreen> createState() => _VerifyPhraseScreenState();
}

class _VerifyPhraseScreenState extends State<VerifyPhraseScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
  List.generate(3, (_) => TextEditingController());

  List<int>? _randomIndices;
  List<String>? _originalPhrase;
  bool _isError = false;
  bool _isButtonEnabled = false;
  late AnimationController _shakeController;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_originalPhrase == null) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is List<String>) {
        _originalPhrase = args;
        _generateRandomIndices();
      }
    }
  }

  void _generateRandomIndices() {
    final list = List<int>.generate(12, (i) => i)..shuffle();
    setState(() {
      _randomIndices = list.take(3).toList()..sort();
    });
  }

  void _validateInputs() {
    setState(() {
      _isButtonEnabled = _controllers.every((c) => c.text.trim().isNotEmpty);
      if (_isError) _isError = false;
    });
  }

  Future<void> _verifyAndSubmit() async {
    if (_originalPhrase == null || _randomIndices == null) return;

    var allCorrect = true;
    for (var i = 0; i < 3; i++) {
      final userInput = _controllers[i].text.trim().toLowerCase();
      final correctWord =
      _originalPhrase![_randomIndices![i]].trim().toLowerCase();
      if (userInput != correctWord) {
        allCorrect = false;
        break;
      }
    }

    if (allCorrect) {
      await Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      setState(() => _isError = true);
      await _shakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_randomIndices == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: AppColors.primary,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                t.seed.verify_title,
                style: textTheme.displayLarge?.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _isError ? t.seed.verify_error : t.seed.verify_desc,
                style: textTheme.bodyMedium?.copyWith(
                  color: _isError ? AppColors.error : null, // статичний error
                  fontWeight: _isError ? FontWeight.bold : null,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

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
                        _randomIndices![index] + 1,
                        _controllers[index],
                        colors,
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 40),
              Image.asset(AppAssets.logo, height: 170, width: 170, fit: BoxFit.contain),
              const SizedBox(height: 60),

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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberedField(
      BuildContext context,
      int number,
      TextEditingController controller,
      AppColorScheme colors,
      ) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        SizedBox(
          width: 35,
          child: Text(
            '$number.',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.primary,              // статичний
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
              color: colors.surface,                 // адаптивний — без isLight
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isError
                    ? AppColors.error.withOpacity(0.5)    // статичний
                    : AppColors.primary.withOpacity(0.15), // статичний
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
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
                    color: colors.textSecondary,     // адаптивний
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