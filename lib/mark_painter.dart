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
    final paint = Paint();

    paint.color = Colors.red;

    for (final mark in marks) {
      if (mark.type == 0){
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(mark.position, 8, paint);
      } else if (mark.type == 1){
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 2;
        canvas.drawCircle(mark.position, 8, paint);
      } else if (mark.type == 2){
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 4;

        // Calculate cross lines based on position and size
        double halfSize = 8;
        Offset topLeft = mark.position - Offset(halfSize, halfSize);
        Offset topRight = mark.position + Offset(halfSize, -halfSize);
        Offset bottomLeft = mark.position + Offset(-halfSize, halfSize);
        Offset bottomRight = mark.position + Offset(halfSize, halfSize);

        // Draw the cross
        canvas.drawLine(topLeft, bottomRight, paint);
        canvas.drawLine(topRight, bottomLeft, paint);
      } else if(mark.type == 3){
        paint.strokeCap = StrokeCap.round;
        canvas.drawLine(mark.position, mark.endPosition!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Redraw whenever the marks list changes
  }
}
