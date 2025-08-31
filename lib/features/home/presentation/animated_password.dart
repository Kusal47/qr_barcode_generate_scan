import 'package:flutter/cupertino.dart';

class AnimatedPassword extends StatefulWidget {
  final String password;
  final bool isVisible;
  final TextStyle? textStyle;
  final double charInterval;

  const AnimatedPassword({
    super.key,
    required this.password,
    required this.isVisible,
    this.textStyle,
    this.charInterval = 0.1,
  });

  @override
  State<AnimatedPassword> createState() => _AnimatedPasswordState();
}

class _AnimatedPasswordState extends State<AnimatedPassword> {
  String displayText = '';

  @override
  void didUpdateWidget(covariant AnimatedPassword oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) _animate(widget.isVisible);
  }

  Future<void> _animate(bool show) async {
    for (int i = 0; i <= widget.password.length; i++) {
      await Future.delayed(Duration(milliseconds: (widget.charInterval * 1000).toInt()));
      if (!mounted) return;
      setState(() {
        displayText = show
            ? widget.password.substring(0, i) + '•' * (widget.password.length - i)
            : widget.password.substring(0, widget.password.length - i) + '•' * i;
      });
    }
  }

  @override
  Widget build(BuildContext context) =>
      Text(displayText.isEmpty ? '•' * widget.password.length : displayText, style: widget.textStyle);
}
