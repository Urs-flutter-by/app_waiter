import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final double gridSize, screenWidth, screenHeight;

  GridPainter({
    required this.gridSize,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double x = 0; x <= screenWidth; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, screenHeight), paint);
    }
    for (double y = 0; y <= screenHeight; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(screenWidth, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}