import 'package:flutter/material.dart';
import '../utils/strings.dart';

Future<bool?> showSOSConfirmDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (_) => const _SOSConfirmDialog(),
  );
}

class _SOSConfirmDialog extends StatelessWidget {
  const _SOSConfirmDialog();

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE1E2DE),
          border: Border.all(color: const Color(0xFFC0392B), width: 2),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 30,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFC0392B), Color(0xFFA93226)],
                ),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(6)),
              ),
              child: Text(
                s.sosDialogTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        color: Color(0xFF2A3428),
                        fontSize: 13,
                        height: 1.6,
                      ),
                      children: [
                        TextSpan(text: s.sosDialogIntroPrefix),
                        TextSpan(
                          text: s.sosDialogIntroBold,
                          style: const TextStyle(
                            color: Color(0xFF9B1B1B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: s.sosDialogIntroSuffix),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5DCD6),
                      border: Border.all(color: const Color(0xFFA0AA96)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Bullet(
                          mark: '✓',
                          markColor: const Color(0xFF3D6B35),
                          text: s.sosBullet72h,
                        ),
                        const SizedBox(height: 4),
                        _Bullet(
                          mark: '✓',
                          markColor: const Color(0xFF3D6B35),
                          text: s.sosBulletDarkMode,
                        ),
                        const SizedBox(height: 4),
                        _Bullet(
                          mark: '!',
                          markColor: const Color(0xFFD67B37),
                          text: s.sosBulletCooldown,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _Button(
                          label: s.cancel,
                          filled: false,
                          onTap: () => Navigator.of(context).pop(false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _Button(
                          label: s.sosActivate,
                          filled: true,
                          onTap: () => Navigator.of(context).pop(true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String mark;
  final Color markColor;
  final String text;
  const _Bullet(
      {required this.mark, required this.markColor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          mark,
          style: TextStyle(
            color: markColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(color: Color(0xFF2A3428), fontSize: 11),
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;
  const _Button({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          gradient: filled
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFC0392B), Color(0xFFA93226)],
                )
              : null,
          color: filled ? null : const Color(0xFFCCD2C6),
          border: Border.all(
            color: filled
                ? const Color(0xFFE74C3C)
                : const Color(0xFFA0AA96),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: filled ? Colors.white : const Color(0xFF3A4A36),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
