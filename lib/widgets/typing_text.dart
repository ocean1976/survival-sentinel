import 'dart:async';
import 'package:flutter/material.dart';

class TypingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Color cursorColor;
  final Duration charDuration;
  final VoidCallback? onProgress;
  final VoidCallback? onComplete;

  const TypingText({
    super.key,
    required this.text,
    required this.style,
    required this.cursorColor,
    this.charDuration = const Duration(milliseconds: 15),
    this.onProgress,
    this.onComplete,
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  Timer? _typeTimer;
  Timer? _blinkTimer;
  int _visibleChars = 0;
  bool _cursorOn = true;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _startTyping();
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() => _cursorOn = !_cursorOn);
    });
  }

  void _startTyping() {
    _typeTimer = Timer.periodic(widget.charDuration, (timer) {
      if (!mounted) return;
      if (_visibleChars >= widget.text.length) {
        timer.cancel();
        setState(() => _done = true);
        widget.onComplete?.call();
        return;
      }
      setState(() => _visibleChars++);
      widget.onProgress?.call();
    });
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.text.substring(0, _visibleChars);
    return Text.rich(
      TextSpan(
        style: widget.style,
        children: [
          TextSpan(text: visible),
          TextSpan(
            text: _cursorOn ? '█' : ' ',
            style: widget.style.copyWith(color: widget.cursorColor),
          ),
          if (!_done)
            const TextSpan(text: ''),
        ],
      ),
    );
  }
}
