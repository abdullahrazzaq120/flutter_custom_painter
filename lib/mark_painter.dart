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
    // final focusPaint = Paint()
    //   ..color = Colors.teal
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 3.0;

    for (final mark in marks) {
      paint.color = mark.isFocus ? Colors.teal : Colors.red;

      if (mark.type == 0) {
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(mark.position, markRadius, paint);

        // // Draw border if focused
        // if (mark.isFocus) {
        //   canvas.drawCircle(mark.position, markRadius + 4.0, focusPaint);
        // }
      } else if (mark.type == 1) {
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 2;
        canvas.drawCircle(mark.position, markRadius, paint);

        // // Draw border if focused
        // if (mark.isFocus) {
        //   focusPaint.strokeWidth = 2;
        //   canvas.drawCircle(mark.position, markRadius + 4.0, focusPaint);
        // }
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

        // // Draw border if focused
        // if (mark.isFocus) {
        //   canvas.drawLine(topLeft, bottomRight, focusPaint);
        //   canvas.drawLine(topRight, bottomLeft, focusPaint);
        // }
      } else if (mark.type == 3) {
        paint.strokeCap = StrokeCap.round;
        paint.strokeWidth = 4;
        canvas.drawLine(mark.position, mark.endPosition!, paint);

        // // Highlight the line if it's focused
        // if (mark.isFocus) {
        //   focusPaint.strokeCap = StrokeCap.round;
        //   focusPaint.strokeWidth = 4;
        //   canvas.drawLine(mark.position, mark.endPosition!, focusPaint);
        // }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Redraw whenever the marks list changes
  }
}
