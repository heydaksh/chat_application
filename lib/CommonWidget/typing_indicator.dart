import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index, Size size) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        double delay = index * 0.2;
        double value = (_controller.value - delay);

        if (value < 0) value += 1;

        double scale = 0.6 + (0.4 * (1 - (value - 0.5).abs() * 2));

        return Transform.scale(
          scale: scale,
          child: Container(
            width: size.width / 40,
            height: size.width / 40,
            margin: EdgeInsets.symmetric(horizontal: size.width / 120),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.symmetric(
        horizontal: size.width / 25,
        vertical: size.height / 70,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [_buildDot(0, size), _buildDot(1, size), _buildDot(2, size)],
      ),
    );
  }
}
