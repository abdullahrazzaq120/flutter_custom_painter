/*
 * Created by Abdullah Razzaq on 10/12/2024.
*/
import 'package:flutter/material.dart';

import 'mark.dart';

class MarkPainter extends CustomPainter {
  final List<Mark> marks;

  MarkPainter({required this.marks});

  @override
  void paint(Canvas canvas, Size size) {
    const markRadius = 6.0;

    final paint = Paint();
    final borderPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Helper function to draw a focus border
    void drawFocusBorder(Offset center) {
      canvas.drawRect(
        Rect.fromCenter(
          center: center,
          width: 30,
          height: 30,
        ),
        borderPaint,
      );
    }

    for (final mark in marks) {
      paint.color = Colors.red;

      // To draw a rectangular border around the mark:
      if (mark.isFocus) {
        drawFocusBorder(mark.position);
        if (mark.type == 3 && mark.endPosition != null) {
          drawFocusBorder(mark.endPosition!);
        }
      }

      switch (mark.type) {
        case 0: // Filled circle
          paint.style = PaintingStyle.fill;
          canvas.drawCircle(mark.position, markRadius, paint);
          break;
        case 1: // Stroked circle
          paint.style = PaintingStyle.stroke;
          paint.strokeWidth = 3;
          canvas.drawCircle(mark.position, markRadius, paint);
          break;
        case 2: // Cross
          paint.style = PaintingStyle.stroke;
          paint.strokeWidth = 3;

          // Calculate cross lines based on position and size
          const double halfSize = 8;
          final Offset topLeft = mark.position - const Offset(halfSize, halfSize);
          final Offset topRight = mark.position + const Offset(halfSize, -halfSize);
          final Offset bottomLeft = mark.position + const Offset(-halfSize, halfSize);
          final Offset bottomRight = mark.position + const Offset(halfSize, halfSize);

          // Draw the cross
          canvas.drawLine(topLeft, bottomRight, paint);
          canvas.drawLine(topRight, bottomLeft, paint);
          break;
        case 3: // Line
          paint.strokeCap = StrokeCap.round;
          paint.strokeWidth = 4;
          if (mark.endPosition != null) {
            canvas.drawLine(mark.position, mark.endPosition!, paint);
          }
          break;
        default:

          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Redraw whenever the marks list changes
  }
}
