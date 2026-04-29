import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/i18n/strings.g.dart';

class SecretPhraseScreen extends StatefulWidget {
  final bool isSetup;

  const SecretPhraseScreen({super.key, this.isSetup = false});

  @override
  State<SecretPhraseScreen> createState() => _SecretPhraseScreenState();
}

class _SecretPhraseScreenState extends State<SecretPhraseScreen> {
  final List<String> seedPhrase = [
    'apple', 'forest', 'shield', 'river',
    'planet', 'window', 'crypto', 'secure',
    'cloud', 'alpha', 'matrix', 'delta',
  ];

  final List<TextEditingController> _controllers =
  List.generate(12, (_) => TextEditingController());
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    if (!widget.isSetup) {
      for (final c in _controllers) {
        c.addListener(_validateInputs);
      }
    }
  }

  void _validateInputs() {
    setState(() {
      _isButtonEnabled = _controllers.every((c) => c.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onSubmit() {
    if (widget.isSetup) {
      Navigator.pushNamed(context, '/verify-seed', arguments: seedPhrase);
    } else {
      // TODO: логіка входу через сід-фразу
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isSetup
        ? _buildSetupView(context)
        : _buildLoginView(context);
  }

  // ── Вигляд для СТВОРЕННЯ ──
  Widget _buildSetupView(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                t.seed.title,
                style: textTheme.displayLarge?.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // ── Попередження ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColors.error.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  t.seed.warning,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.textPrimary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

              // ── Грід слів ──
              Expanded(
                child: GridView.builder(
                  itemCount: seedPhrase.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.8,
                  ),
                  itemBuilder: (context, index) =>
                      _buildWordCard(context, index + 1, seedPhrase[index], colors),
                ),
              ),

              // ── Скопіювати ──
              TextButton.icon(
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: seedPhrase.join(' ')),
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.seed.copy_done)),
                  );
                },
                icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.primary),
                label: Text(
                  t.seed.copy,
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Кнопка ──
              FilledButton(
                onPressed: _onSubmit,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  t.seed.saved_button,
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

  // ── Вигляд для ВХОДУ ──
  Widget _buildLoginView(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                t.seed.login_title,
                style: textTheme.displayLarge?.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                t.seed.login_subtitle,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // ── Грід полів вводу ──
              Expanded(
                child: GridView.builder(
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
                    colors,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Image.asset(AppAssets.logo, height: 80, width: 80, fit: BoxFit.contain),
              const SizedBox(height: 16),

              // ── Кнопка ──
              FilledButton(
                onPressed: _isButtonEnabled ? _onSubmit : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  t.common.login,
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

  // ── Картка зі словом (setup) ──
  Widget _buildWordCard(
      BuildContext context,
      int number,
      String word,
      AppColorScheme colors,
      ) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,                         // адаптивний
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.5),  // статичний
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                color: AppColors.primary.withOpacity(0.7),  // статичний
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

  // ── Картка з полем вводу (login) ──
  Widget _buildInputCard(
      BuildContext context,
      int number,
      TextEditingController controller,
      AppColorScheme colors,
      ) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,                         // адаптивний — без isLight
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),  // статичний
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                color: AppColors.primary.withOpacity(0.7),
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
                hintText: t.seed.word_hint,
                hintStyle: TextStyle(
                  color: colors.textSecondary,         // адаптивний
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