import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> dot1;
  late Animation<double> dot2;
  late Animation<double> dot3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();

    dot1 = Tween(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    dot2 = Tween(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );

    dot3 = Tween(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildDot(Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: CircleAvatar(radius: 3, backgroundColor: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [buildDot(dot1), buildDot(dot2), buildDot(dot3)]);
  }
}
