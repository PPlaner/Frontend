import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class PinPadView extends StatefulWidget {
  const PinPadView({
    required this.buttonTitle,
    required this.onPinCompleted,
    super.key,
  });

  final String buttonTitle;
  final ValueChanged<String> onPinCompleted;

  @override
  State<PinPadView> createState() => _PinPadViewState();
}

class _PinPadViewState extends State<PinPadView> {
  String _pinCode = '';
  static const int _pinLength = 4;

  void _addDigit(String digit) {
    if (_pinCode.length < _pinLength) {
      setState(() => _pinCode += digit);
    }
  }

  void _removeDigit() {
    if (_pinCode.isNotEmpty) {
      setState(() => _pinCode = _pinCode.substring(0, _pinCode.length - 1));
    }
  }

  void _onSubmit() {
    if (_pinCode.length == _pinLength) {
      widget.onPinCompleted(_pinCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Column(
      children: [
        const Spacer(),

        _buildPinDots(_pinCode.length),

        const SizedBox(height: 30),

        _buildKeypad(colors),

        const Spacer(),

        FilledButton(
          onPressed: _pinCode.length == _pinLength ? _onSubmit : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            backgroundColor: AppColors.primary,
          ),
          child: Text(
            widget.buttonTitle,
            style: textTheme.labelLarge?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildPinDots(int filledLength) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pinLength, (index) {
        final isFilled = index < filledLength;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isFilled ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildKeypad(AppColorScheme colors) {
    return Column(
      children: [
        _buildKeypadRow(['1', '2', '3'], colors),
        const SizedBox(height: 16),
        _buildKeypadRow(['4', '5', '6'], colors),
        const SizedBox(height: 16),
        _buildKeypadRow(['7', '8', '9'], colors),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 94),
            _buildDigitKey('0', colors),
            const SizedBox(width: 24),
            _buildBackspaceKey(),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadRow(List<String> digits, AppColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDigitKey(digits[0], colors),
        const SizedBox(width: 24),
        _buildDigitKey(digits[1], colors),
        const SizedBox(width: 24),
        _buildDigitKey(digits[2], colors),
      ],
    );
  }

  Widget _buildDigitKey(String digit, AppColorScheme colors) {
    return InkWell(
      onTap: () => _addDigit(digit),
      borderRadius: BorderRadius.circular(40),
      child: SizedBox(
        width: 70,
        height: 70,
        child: Center(
          child: Text(
            digit,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: colors.textPrimary, // адаптивний
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey() {
    return InkWell(
      onTap: _removeDigit,
      borderRadius: BorderRadius.circular(40),
      child: const SizedBox(
        width: 70,
        height: 70,
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            color: AppColors.primary, // статичний
            size: 26,
          ),
        ),
      ),
    );
  }
}
