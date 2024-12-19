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
    const markRadius = 10.0;

    final paint = Paint();
    final borderPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    for (final mark in marks) {
      paint.color = Colors.red;

      // To draw a rectangular border around the mark:
      if (mark.isFocus) {
        canvas.drawRect(
          Rect.fromCenter(
            center: mark.position,
            width: 30,
            height: 30,
          ),
          borderPaint,
        );
      }
      if (mark.isFocus && mark.type == 3) {
        // To draw a rectangular border around the mark:
        canvas.drawRect(
          Rect.fromCenter(
            center: mark.position,
            width: 30,
            height: 30,
          ),
          borderPaint,
        );

        // To draw a rectangular border around the mark:
        canvas.drawRect(
          Rect.fromCenter(
            center: mark.endPosition!,
            width: 30,
            height: 30,
          ),
          borderPaint,
        );
      }

      if (mark.type == 0) {
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(mark.position, markRadius, paint);
      } else if (mark.type == 1) {
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 2;
        canvas.drawCircle(mark.position, markRadius, paint);
      } else if (mark.type == 2) {
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 3;

        // Calculate cross lines based on position and size
        double halfSize = 8;
        Offset topLeft = mark.position - Offset(halfSize, halfSize);
        Offset topRight = mark.position + Offset(halfSize, -halfSize);
        Offset bottomLeft = mark.position + Offset(-halfSize, halfSize);
        Offset bottomRight = mark.position + Offset(halfSize, halfSize);

        // Draw the cross
        canvas.drawLine(topLeft, bottomRight, paint);
        canvas.drawLine(topRight, bottomLeft, paint);
      } else if (mark.type == 3) {
        paint.strokeCap = StrokeCap.round;
        paint.strokeWidth = 4;
        canvas.drawLine(mark.position, mark.endPosition!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Redraw whenever the marks list changes
  }
}
