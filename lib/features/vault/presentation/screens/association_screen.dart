import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/ui/widgets/back_app_bar.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/i18n/strings.g.dart';

class AssociationScreen extends ConsumerStatefulWidget {
  const AssociationScreen({super.key, this.isSetup = false});

  final bool isSetup;

  @override
  ConsumerState<AssociationScreen> createState() => _AssociationScreenState();
}

class _AssociationScreenState extends ConsumerState<AssociationScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isButtonEnabled = false;
  final RegExp _lettersOnly = RegExp(r'^[a-zA-Zа-яА-ЯіїєґІЇЄҐ]+$');

  bool get _hasError => _controller.text.isNotEmpty && !_isButtonEnabled;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
    _controller.addListener(() {
      final text = _controller.text;
      setState(() {
        _isButtonEnabled = text.length >= 6 && _lettersOnly.hasMatch(text);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (widget.isSetup) {
      Navigator.pushNamed(context, '/secret-setup');
    } else {
      // TODO: перевірити слово-асоціацію і увійти
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(
      context,
    ); // адаптивні кольори (як у profile_screen)
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface, // surface — не хардкод
      appBar: const BackAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ── Заголовок ──
              Text(
                widget.isSetup ? t.setup.word_create : t.setup.word_enter,
                style: textTheme.displayLarge?.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // ── Підзаголовок / помилка ──
              Text(
                widget.isSetup
                    ? t.setup.word_desc_setup
                    : t.setup.word_desc_login,
                style: textTheme.bodyMedium?.copyWith(
                  color: _hasError
                      ? colorScheme
                            .error // error — через colorScheme
                      : colors.textSecondary, // звичайний — через colors
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // ── Поле вводу ──
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: colors.surface, // surface адаптивний
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _hasError
                        ? colorScheme.error.withValues(alpha: 0.5)
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
                    controller: _controller,
                    focusNode: _focusNode,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(fontSize: 16),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      filled: false,
                      hintText: _focusNode.hasFocus ? '' : t.setup.word_hint,
                      hintStyle: TextStyle(
                        color: colors.textSecondary, // адаптивний сірий
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // ── Лого ──
              Image.asset(
                AppAssets.logo,
                height: 170,
                width: 170,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 80),

              // ── Кнопка ──
              FilledButton(
                onPressed: _isButtonEnabled ? _onSubmit : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary, // статичний primary
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text(
                  widget.isSetup ? t.common.register : t.common.login,
                  style: textTheme.labelLarge?.copyWith(
                    color: Colors.white, // білий завжди на primary кнопці
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
