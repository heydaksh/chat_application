import 'package:chat_application/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class Wave extends StatelessWidget {
  const Wave({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ClipPath(
      clipper: VerticalWaveClipper(),
      child: Container(
        width: size.width,
        height: size.height,
        color: AppTheme.primaryColor,
      ),
    );
  }
}

class VerticalWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(size.width * 0.6, 0);

    path.quadraticBezierTo(
      size.width,
      size.height * 0.25,
      size.width * 0.6,
      size.height * 0.5,
    );

    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.75,
      size.width * 0.6,
      size.height,
    );

    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}
