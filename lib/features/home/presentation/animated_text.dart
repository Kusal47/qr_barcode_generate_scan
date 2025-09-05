import 'package:flutter/cupertino.dart';

class AnimatedTextAnimation extends StatefulWidget {
  final String text;
  final bool? isVisible;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final double charInterval;

  const AnimatedTextAnimation({
    super.key,
    required this.text,
    this.isVisible,
    this.textStyle,
    this.charInterval = 0.1,
    this.textAlign,
  });

  @override
  State<AnimatedTextAnimation> createState() => _AnimatedTextAnimationState();
}

class _AnimatedTextAnimationState extends State<AnimatedTextAnimation> {
  String displayText = '';

  @override
  void initState() {
    super.initState();
    if (widget.isVisible == null) {
      _animate(true, masked: false);
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedTextAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != null && widget.isVisible != oldWidget.isVisible) {
      _animate(widget.isVisible!, masked: true);
    }
  }

  Future<void> _animate(bool show, {required bool masked}) async {
    for (int i = 0; i <= widget.text.length; i++) {
      await Future.delayed(Duration(milliseconds: (widget.charInterval * 1000).toInt()));
      if (!mounted) return;
      setState(() {
        if (masked) {
          // password-like animation
          displayText =
              show
                  ? widget.text.substring(0, i) + '•' * (widget.text.length - i)
                  : widget.text.substring(0, widget.text.length - i) + '•' * i;
        } else {
          // plain typing animation
          displayText = widget.text.substring(0, i);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) => Text(
    textAlign: widget.textAlign?? TextAlign.start,
    displayText.isEmpty ? (widget.isVisible == null ? '' : '•' * widget.text.length) : displayText,
    style: widget.textStyle,
  );
}
