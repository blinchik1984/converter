import 'package:flutter/material.dart';

class BlinkingButton extends StatefulWidget {
  final Widget child;
  final Function onPressed;
  final Color color;

  const BlinkingButton({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  @override
  _BlinkingButtonState createState() => _BlinkingButtonState();
}

class _BlinkingButtonState extends State<BlinkingButton>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.decelerate
  );

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: MaterialButton(
        onPressed: () => widget.onPressed(),
        child: widget.child,
        color: widget.color,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}